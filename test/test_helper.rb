require "rubygems"
require "bundler/setup"

require File.join(File.dirname(__FILE__), '..', 'lib', 'peaty')

require 'test/unit'
require 'fakeweb'
FakeWeb.allow_net_connect = false

TEST_TOKEN = "test"

{ "http://www.pivotaltracker.com/services/v3/projects"                => "projects",
  "http://www.pivotaltracker.com/services/v3/projects/125701"         => "project",
  "http://www.pivotaltracker.com/services/v3/projects/125701/stories" => "stories"
}.each do |(uri, fixture)|
  FakeWeb.register_uri(:get, uri, :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "%s.xml" % fixture)))
end

class User < Struct.new(:pivotal_tracker_api_key)
  active_tracker_for :pivotal_tracker_api_key
end
