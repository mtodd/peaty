module Peaty
  
  class Project < Base
    
    def stories(options = {})
      Proxy.new(Story, self.class.connection, options.merge(:project_id => self.id))
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
  
end
