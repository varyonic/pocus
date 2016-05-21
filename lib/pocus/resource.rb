module Pocus
  class Response < OpenStruct; end

  class Resource
    attr_reader :path
    attr_accessor :parent

    def initialize(attributes)
      assign_attributes(attributes)
    end

    def assign_attributes(attributes)
      attributes.each do |ck, v|
        k = underscore(ck)
        self.class.__send__(:attr_accessor, k) unless respond_to?(k)
        send("#{k}=", v)
      end
    end

    def fields
      field_names.reduce(Hash[]) do |hash, field_name|
        hash.tap { |h| h[camelize field_name] = send field_name }
      end
    end

    def get(request_path = '', request_tag = tag, klass = self.class, filters = {})
      response = session.send_request('GET', path+request_path, camelize_filters(filters))
      fail("Expected #{tag}, got #{response.inspect}") unless response[request_tag]
      response[request_tag] = parse_data(response[request_tag], klass)
      Response.new response
    end

    def logger
      session.logger
    end

    def parse_data(data, klass = self.class)
      data.kind_of?(Array) ?
        data.map { |fields| klass.new(fields.merge(parent: self)) } :
        klass.new(data.merge(parent: self))
    end

    def post(request_path = '', request_tag = tag, resource = self)
      response = session.send_request('POST', path+request_path, resource.fields)
      fail("Expected #{request_tag}, got #{response.inspect}") unless response[request_tag]
      assign_attributes(response[request_tag])
      response[request_tag] = self
      Response.new(response)
    end

    def post_multiple(request_path, request_tag, resources)
      response = session.send_request('POST', path+request_path, resources.map(&:fields))
      data = response[request_tag] || fail("Expected #{tag}, got #{response.inspect}")
      data.each_with_index { |fields, idx| resources[idx].assign_attributes(fields) }
      response[request_tag] = resources
      Response.new(response)
    end

    def session
      parent.session
    end

    def tag
      self.class.name.split('::').last.downcase
    end

    protected

    def required(attributes, attr_names)
      missing = attr_names - attributes.keys
      fail "missing required atrributes: #{missing.inspect}" if missing.any?
    end

    def camelize(str)
      return str.to_s unless str.to_s.include?(?_)
      parts = str.to_s.split('_')
      first = parts.shift
      first + parts.each {|s| s.capitalize! }.join
    end

    def camelize_filters(hash)
      hash.reduce({}) do |h, e|
        key = camelize(e[0])
        h[key] = e[1]
        h[key+'SearchType'] = 'eq'
        h
      end
    end

    def field_names
      instance_variables.map { |n| n.to_s.sub('@','').to_sym } - [:session, :parent, :path]
    end

    def underscore(camel_cased_word)
      camel_cased_word.to_s.dup.tap do |word|
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.downcase!
      end
    end
  end
end
