module Peaty
  
  class Base
    attr_accessor :attributes, :connection
    
    def initialize(attributes)
      raise ArgumentError unless attributes.is_a?(Hash)
      @attributes = attributes
    end
    
    def method_missing(method, *args)
      return self.attributes[method.to_s] if respond_to?(method)
      super
    end
    def respond_to?(method)
      self.attributes.key?(method.to_s)
    end
    
    def id
      self.attributes["id"]
    end
    
    class << self
      attr_accessor :connection
      
      def with_connection(connection)
        @connection = connection
        self # chaining
      end
      
      # Takes the XML result, transforms to JSON, parses to objects, and
      # returns an array of results, regardless of one or many results.
      def parse(response, element)
        result = JSON.parse(XmlToJson.transform(response))
        Array.wrap(result[element]).map{ |r| new(r) }
      end
      
      def find(*args)
        options = args.extract_options!
        selection = args.shift
        case selection
        when Numeric  then self.find_by_id(selection, options)
        when :first   then self.first(options)
        when :all     then self.all(options)
        end
      end
      
      def find_by_id(id, options = {})
        # puts JSON.parse(XmlToJson.transform(self.connection[self.member_path(id, options)].get.body)).inspect
        
        self.parse(self.connection[self.member_path(id, options)].get.body, self.element).
          first.
          tap{ |e| e.connection = self.connection }
      end
      
      def all(options = {})
        self.parse(self.connection[self.collection_path(options)].get.body, self.element.pluralize).
          each { |e| e.connection = self.connection }
      end
      
      def first(options = {})
        self.all(options).first
      end
    end
  end
  
end
