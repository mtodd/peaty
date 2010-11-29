module Peaty
  
  class Proxy
    attr_accessor :target, :connection, :options
    def initialize(target, connection, options = {})
      @target, @connection, @options = target, connection, options
    end
    def method_missing(method, *args)
      options = args.extract_options!
      args << @options.merge(options)
      @target.with_connection(@connection).send(method, *args)
    end
  end
  
end
