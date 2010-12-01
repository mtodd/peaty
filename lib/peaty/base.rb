module Peaty
  
  class Base
    attr_accessor :attributes, :connection
    
    FILTERS = [
      :id, :type, :state, :label, :has_attachment,
      :created_since, :modified_since,
      :requester, :owner,
      :mywork,
      :integration, :external_id, :has_external_id,
      :includedone
    ]
    
    def initialize(attrs)
      raise ArgumentError unless attrs.is_a?(Hash)
      @connection = self.class.connection
      # if we get a hash like {"item"=>{...}}, pull out the attributes
      @attributes = if attrs.key?(self.class.element);  attrs.dup.delete(self.class.element) 
                    else                                attrs.dup
                    end
    end
    
    def method_missing(method, *args)
      return self.attributes[method.to_s] if respond_to?(method)
      super
    end
    def respond_to?(method)
      super or self.attributes.key?(method.to_s)
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
        Array.wrap(result[element] || result[element.pluralize]).map{ |r| new(r) }
      end
      
      def find(*args)
        options = args.extract_options!
        selection = args.shift
        case selection
        when :first;  self.first(options)
        when :all;    self.all(options)
        when Array;   selection.map{ |s| self.find_by_id(s, options) }
        when Numeric; self.find_by_id(selection, options)
        else          self.find_by_id(selection, options)
        end
      end
      
      def find_by_id(id, options = {})
        self.parse(self.connection[self.member_path(id, options)].get(:params => self.filter_options(options)).body, self.element).
          first.
          tap{ |e| e.connection = self.connection }
      end
      
      def all(options = {})
        self.parse(self.connection[self.collection_path(options)].get(:params => self.filter_options(options)).body, self.element).
          each { |e| e.connection = self.connection }
      end
      
      def first(options = {})
        self.all(options).first
      end
      
      def filter_options(options = {}, filter = [])
        options = options.dup # make sure we're working on a copy
        # and delete any keys not supported for queries
        options.each { |(k,_)| options.delete(k) unless FILTERS.include?(k.to_sym) }
        
        FILTERS.each do |term|
          value = Array.wrap(options.delete(term))
          filter << "%s:%s" % [ term,
                                value.map do |v|
                                  v = %("%s") % v if v.to_s =~ /\s/
                                  v
                                end.join(',') ] unless value.empty?
        end
        
        # handle the rest of the filter strings
        Array.wrap(options.delete(:rest)).each do |value|
          value = %("%s") % value if value.to_s =~ /\s/
          filter << value
        end
        
        return options if filter.empty?
        options.merge(:filter => filter.join(" "))
      end
    end
  end
  
end
