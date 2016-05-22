module Pocus
  class Association < Array
    attr_reader :owner, :path, :klass

    def initialize(owner, name, options)
      @owner = owner
      @path = options[:path] || "/#{name}"
      @klass = Object.const_get("Pocus::".concat(options[:class] || camelize(name)))
    end

    def all
      owner.get_multiple(path, klass)
    end

    def find(id)
      owner.get("#{path}/#{id}", klass)
    end

    def where(filters)
      owner.get_multiple(path, klass, filters)
    end
  end
end
