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

    def tasks(options = {})
      Proxy.new(Task, self.class.connection, options.merge(:project_id => self.project_id,
                                                           :story_id   => self.id))
    end

    # Moves a story before or after another story
    #
    #     story1.move(:before => story2)
    #     story2.move(:after => story1)
    def move(options)
      @error = nil

      move_options = { :project_id => project_id }
      if options[:before]
        move_options.merge!({ :type => :before, :target_id => options[:before].id })
      elsif options[:after]
        move_options.merge!({ :type => :after, :target_id => options[:after].id })
      else
        raise ArgumentError, "Must specify :before => story or :after => story"
      end

      self.connection[self.class.move_path(id, move_options)].post("").body

      self
    rescue RestClient::UnprocessableEntity => e
      @error = JSON.parse(XmlToJson.transform(e.response.body))["message"]
      false
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
      def move_path(id, options = {})
        "/projects/%i/stories/%i/moves?move[move]=%s&move[target]=%i" % [options[:project_id].to_i, id, options[:type], options[:target_id].to_i]
      end
      
      ### Filters
      
      def releases(options = {})
        self.filter(:type => :release)
      end
    end
    
  end
  
end
