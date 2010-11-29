module Peaty
  
  class Iteration < Base
    
    def stories(options = {})
      Array.wrap(self.attributes["stories"]).map do |story|
        Story.with_connection(self.connection).new(story)
      end
    end
    
    class << self
      def element
        "iteration"
      end
      def collection_path(options = {})
        "/projects/%i/iterations" % options[:project_id].to_i
      end
      def member_path(group, options = {})
        "/projects/%i/iterations/%s" % [options[:project_id].to_i, group]
      end
    end
    
  end
  
end
