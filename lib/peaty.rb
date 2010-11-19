require 'logger'

require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/core_ext/benchmark'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/reverse_merge'

require 'nokogiri'
require 'xml_to_json'
require 'yajl/json_gem'

module Peaty
  
  def self.root
    @root ||= Pathname.new(__FILE__).dirname.parent
  end
  
  module Integration
    extend ActiveSupport::Concern
    
    included do
      self.__pivotal_tracker_options.tap do |opts|
        alias_method [opts[:method_prefix], :projects].compact.map(&:to_s).join('_').to_sym, :__pivotal_tracker_projects
      end
    end
    
    module InstanceMethods
      def __pivotal_tracker_connection
        @__pivotal_tracker_connection ||= begin
          RestClient.log ||= STDOUT
          RestClient::Resource.new("http://www.pivotaltracker.com/services/v3", :headers => {"X-TrackerToken" => self.send(self.class.__pivotal_tracker_options[:attribute])})
        end
      end
      def __pivotal_tracker_projects
        Proxy.new(Project, self.__pivotal_tracker_connection, :user => self)
      end
    end
  end
  
  ### Models
  
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
  
  class Project < Base
    
    def stories(options = {})
      Proxy.new(Story, self.class.connection, options)
    end
    
    class << self
      def element
        "project"
      end
      def collection_path(options = {})
        "/projects"
      end
      def member_path(id, options = {})
        "/projects/%i" % id
      end
    end
  end
  
  class Story < Base
    
    def project
      Project.with_connection(self.class.connection).find(self.project_id)
    end
    
    class << self
      def element
        "story"
      end
      def collection_path(options = {})
        "/projects/%i/stories" % options[:project].id
      end
      def member_path(id, options = {})
        "/projects/%i/stories/%i" % [options[:project].id, id]
      end
    end
  end
  
  ### Helpers
  
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

class Object
  def self.active_tracker_for(attribute, options = {})
    raise ArgumentError unless instance_methods.include?(attribute.to_s)
    
    options = options.with_indifferent_access
    options.reverse_merge!( :attribute => attribute,
                            :method_prefix => :pivotal_tracker )
    
    class << self; attr_accessor :__pivotal_tracker_options; end
    self.__pivotal_tracker_options = options
    self.send(:include, Peaty::Integration)
  end
end
