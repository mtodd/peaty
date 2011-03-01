module Peaty
  
  class Proxy
    attr_accessor :target, :connection, :options
    
    def initialize(target, connection, options = {})
      @target, @connection, @options = target, connection, options.with_indifferent_access
    end
    
    def method_missing(method, *args)
      return @target.method(method).unbind.bind(self).call(*args) if @target.class.respond_to?(method)
      options = args.extract_options!
      args << @options.merge(options)
      @target.with_connection(@connection).send(method, *args)
    end
    
    def filter(*args)
      options = args.extract_options!
      options.each do |(key, value)|
        @options[key] = Array.wrap(@options.delete(:key)).concat(Array.wrap(value))
      end
      
      @options[:rest] = Array.wrap(@options.delete(:rest)).concat(args)
      
      self
    end
    
    def self.build(attrs = {})
      @target.build(@options.merge(attrs.with_indifferent_access))
    end
  end
  
end
