module Peaty
  
  class Story < Base
    
    def story_type
      self.attributes["story_type"].to_sym if story_type?
    end
    alias type story_type
    
    # chores, bugs, releases may or may not have estimates
    def estimate
      self.attributes["estimate"].to_i
    end
    
    def project
      Project.with_connection(self.class.connection).find(self.project_id)
    end
    
    class << self
      def element
        "story"
      end
      def collection_path(options = {})
        "/projects/%i/stories" % options[:project_id].to_i
      end
      def member_path(id, options = {})
        "/projects/%i/stories/%i" % [options[:project_id].to_i, id]
      end
      
      ### Filters
      
      def releases(options = {})
        self.filter(:type => :release)
      end
    end
    
  end
  
end
