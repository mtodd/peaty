module Peaty
  
  class Story < Base
    
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
    end
    
  end
  
end
