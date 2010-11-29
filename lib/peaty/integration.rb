module Peaty
  
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
  
end

class Object
  def self.pivotal_tracker_for(attribute, options = {})
    raise ArgumentError unless instance_methods.include?(attribute.to_s)
    
    options = options.with_indifferent_access
    options.reverse_merge!( :attribute => attribute,
                            :method_prefix => :pivotal_tracker )
    
    class << self; attr_accessor :__pivotal_tracker_options; end
    self.__pivotal_tracker_options = options
    self.send(:include, Peaty::Integration)
  end
end
