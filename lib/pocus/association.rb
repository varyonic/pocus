module Pocus
  class Association < Array
    attr_reader :owner, :path, :klass

    def initialize(owner, name, options)
      @owner = owner
      @path = options[:path] || "/#{name}"
      @klass = Object.const_get('Pocus::'.concat(options[:class] || camelize(name)))
    end

    def all
      @all ||= owner.get_multiple(path, klass)
    end

    def create(fields_multiple)
      if fields_multiple.is_a?(Array)
        owner.post_multiple(path, klass, fields_multiple)
      else
        response = owner.post_multiple(path, klass, [fields_multiple])
        return response if response.empty?
        resource = response.first
        resource.assign_attributes(errors: response.errors || [], warnings: response.warnings || [])
        resource
      end
    end

    def find(id)
      owner.get("#{path}/#{id}", klass)
    end

    def find_or_create_by(attributes)
      where(attributes).first || create(attributes)
    end

    def where(filters)
      owner.get_multiple(path, klass, filters)
    end
  end
end
