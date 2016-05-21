require 'benchmark'
require 'json'
require 'logger'

# See https://www.icontact.com/developerportal/documentation
module Pocus
  class Session
    BASE_URL = 'https://api.invoc.us/icp'
    attr_reader :credentials
    attr_accessor :logger

    def initialize(app_id: '', username: '', password: '', logger: Logger.new('/dev/null'))
      @credentials = {
        'API-AppId'    => app_id,
        'API-Username' => username,
        'API-Password' => password
      }
      @logger = logger
    end

    def send_request(method, path, fields = {})
      send_uri_request(URI(BASE_URL+path), method, request_data(fields))
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

    def send_uri_request(uri, method, data)
      logger.info "request = #{uri.to_s}#{data ? '?'+data : ''}"
      response = nil
      tms = Benchmark.measure do
        response = https(uri).send_request(method, uri.to_s, data, headers.merge(credentials))
      end
      logger.info("API response (#{tms.real}s): #{response.inspect} #{response.body}")

      fail "Unexpected response: #{response.inspect}, #{response.body}" unless response.code == '200'
      JSON.parse(response.body)
    end
  end
end
