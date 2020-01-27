module Pocus
  # Combine array of resources returned by API with error and warning attributes.
  class ResponseArray < Array
    attr_reader :errors, :warnings

    def initialize(resources, errors, warnings)
      @errors = (errors || [])
      @warnings = (warnings.reject { |w| w =~ /Your account is past due/ } || [])
      super resources
    end
  end

  # Base class for API resources.
  class Resource
    attr_reader :path
    attr_accessor :parent

    class << self
      attr_accessor :path, :primary_key

      def associations
        @associations ||= {}
      end

      def has_many(name, options = {})
        attr_accessor(name)
        associations[name] = options
      end

      def tag
        name.split('::').last.downcase
      end

      def tag_multiple
        tag.concat('s')
      end
    end

    def initialize(attributes)
      assign_attributes(attributes)
      self.class.associations.each_pair do |name, options|
        send("#{name}=", Association.new(self, name, options))
      end
    end

    def assign_attributes(attributes)
      attributes.each do |ck, v|
        k = underscore(ck)
        self.class.__send__(:attr_accessor, k) unless respond_to?(k)
        send("#{k}=", v)
      end
    end

    def delete
      session.send_request('DELETE', path) == []
    end
    alias destroy delete

    def fields
      field_names.reduce(Hash[]) do |hash, field_name|
        hash.tap { |h| h[camelize field_name] = send field_name }
      end
    end

    # Fetch and instantiate a single resource from a path.
    def get(request_path, klass)
      response = session.send_request('GET', path + request_path)
      data = response.fetch(klass.tag)
      resource = klass.new(data.merge(parent: self))
      resource.assign_errors(response)
      resource
    end

    def get_multiple(request_path, klass, filters = {})
      request_data = URI.encode_www_form(camelize_fields filters)
      response = session.send_request('GET', path + request_path + '?' + request_data)
      data = response.fetch(klass.tag_multiple) || []
      resources = data.map { |fields| klass.new(fields.merge(parent: self)) }
      ResponseArray.new(resources, response['errors'], response['warnings'])
    end

    def id
      send self.class.primary_key
    end

    def logger
      session.logger
    end

    def path
      "#{parent ? parent.path : ""}/#{self.class.path}/#{id}"
    end

    def post
      response = session.send_request('POST', path, fields)
      assign_attributes(response.fetch(self.class.tag))
      assign_errors(response)
      self
    rescue UnexpectedHttpResponse => e
      response = JSON.parse(e.response.body)
      response['errors'] || response['warnings'] or raise
      assign_errors(response)
      self
    end

    def post_multiple(request_path, klass, fields_multiple)
      data = fields_multiple.map { |fields| camelize_fields(fields) }
      response = session.send_request('POST', path + request_path, data)
      resources = response.fetch(klass.tag_multiple).map { |fields| klass.new(fields.merge(parent: self)) }
      ResponseArray.new(resources, response['errors'], response['warnings'])
    end

    # Fetch and update this resource from a path.
    def reload
      response = session.send_request('GET', path)
      assign_attributes(response.fetch(self.class.tag))
      assign_errors(response)
      self
    end

    def session
      parent.session
    end

    def marshal_dump
      instance_variables.each_with_object({}) { |k, h| h[k[1..-1]] = send(k[1..-1]) }
    end

    def marshal_load(attributes)
      assign_attributes(attributes)
    end

    protected

    def required(attributes, attr_names)
      missing = attr_names - attributes.keys
      fail "missing required atrributes: #{missing.inspect}" if missing.any?
    end

    def camelize(str)
      return str.to_s unless str.to_s.include?('_')
      parts = str.to_s.split('_')
      first = parts.shift
      first + parts.each(&:capitalize!).join
    end

    def camelize_fields(hash)
      hash.reduce({}) do |h, e|
        h[camelize e[0]] = e[1]
        h
      end
    end

    def camelize_filters(hash)
      hash.reduce({}) do |h, e|
        key = camelize(e[0])
        h[key] = e[1]
        h[key + 'SearchType'] = 'eq'
        h
      end
    end

    def field_names
      instance_variables.map { |n| n.to_s.sub('@', '').to_sym } - [:session, :parent, :path]
    end

    def assign_errors(response)
      assign_attributes(errors: response['errors'] || [], warnings: response['warnings'].reject { |w| w =~ /Your account is past due/ } || [])
    end

    def underscore(camel_cased_word)
      camel_cased_word.to_s.dup.tap do |word|
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.downcase!
      end
    end
  end
end
