module Peaty
  class Task < Base
    def complete?
      self.attributes["complete"] == "true"
    end

    def position
      self.attributes["position"].to_i
    end

    def story
      Story.with_connection(self.class.connection).find(self.story_id)
    end

    class << self
      def element
        "task"
      end
      def collection_path(options = {})
        "/projects/%i/stories/%i/tasks" % [options[:project_id].to_i, options[:story_id].to_i]
      end
      def member_path(id, options = {})
        "/projects/%i/stories/%i/tasks/%i" % [options[:project_id].to_i, options[:story_id].to_i, id]
      end
    end
  end
end
