module Peaty
  
  class Project < Base
    
    def users(options = {})
      Array.wrap(self.memberships).map do |membership|
        membership = membership["membership"] if membership.key?("membership")
        User.new(membership["person"])
      end
      
    end
    
    def stories(options = {})
      Proxy.new(Story, self.class.connection, options.merge(:project_id => self.id))
    end
    
    def features(options = {})
      self.stories.filter(:type => :feature)
    end
    def releases(options = {})
      self.stories.filter(:type => :release)
    end
    def chores(options = {})
      self.stories.filter(:type => :chore)
    end
    def bugs(options = {})
      self.stories.filter(:type => :bug)
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
