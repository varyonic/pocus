require 'benchmark'
require 'json'
require 'logger'
require 'net/http'
require 'openssl'

# See https://www.icontact.com/developerportal/documentation
module Pocus
  class UnexpectedHttpResponse < RuntimeError
    attr_reader :response
    def initialize(response)
      @response = response
      super "Unexpected response [#{response.code}] #{response.body}"
    end
  end

  # Sends authenticated JSON requests to remote service using HTTPS.
  class Session
    attr_reader :base_url
    attr_reader :credentials
    attr_accessor :logger

    def initialize(host: 'api.invoc.us', app_id:, username:, password:, logger: Logger.new('/dev/null'))
      @base_url = "https://#{host}/icp".freeze
      @credentials = {
        'API-AppId'    => app_id,
        'API-Username' => username,
        'API-Password' => password
      }
      @logger = logger
    end

    # 'Pro' is legacy as moniker dropped.
    def pro?
      base_url =~ /invoc.us/
    end

    # Accepts hash of fields to send.
    # Returns parsed response body, always a hash.
    def send_request(method, path, fields = {})
      response = send_logged_request(URI(base_url + path), method, request_data(fields))
      fail UnexpectedHttpResponse, response unless response.is_a? Net::HTTPSuccess
      JSON.parse(response.body)
    end

    protected

    def headers(type = 'application/json')
      Hash['API-Version' => '2.2', 'Accept' => type, 'Content-Type' => type]
    end

    def https(uri)
      Net::HTTP.new(uri.host, uri.port).tap do |http|
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    def request_data(fields)
      fields.to_json unless fields.empty?
    end

    def send_logged_request(uri, method, data)
      log_request_response(uri, method, data) do |u, m, d|
        https(uri).send_request(m, u.to_s, d, headers.merge(credentials))
      end
    end

    def log_request_response(uri, method, data)
      logger.info  "[#{self.class.name}] request = #{method} #{uri}#{data ? '?' + data : ''}"
      response = nil
      tms = Benchmark.measure do
        response = yield uri, method, data
      end
      logger.info  "[#{self.class.name}] response (#{ms(tms)}ms): #{response.inspect} #{response.body}"
      response
    end

    def ms(tms)
      (tms.real*1000).round(3)
    end
  end
end
