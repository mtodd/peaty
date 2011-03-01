require "rubygems"
require "bundler/setup"


require File.join(File.dirname(__FILE__), '..', 'lib', 'peaty')

require 'test/unit'

require 'fakeweb'
FakeWeb.allow_net_connect = false

TEST_TOKEN = "test"

# USER_ID     = 399324
PROJECT_ID  = 153937
STORY_ID    = 6821071
RELEASE_ID  = 6821121

uri = "http://www.pivotaltracker.com/services/v3"
{ "/projects"                                             => "projects",
  "/projects/#{PROJECT_ID}"                               => "project",
  "/projects/#{PROJECT_ID}/stories"                       => "stories",
  "/projects/#{PROJECT_ID}/iterations"                    => "iterations",
  "/projects/#{PROJECT_ID}/iterations/done"               => "iterations_done",
  "/projects/#{PROJECT_ID}/stories/#{STORY_ID}"           => "story",
  "/projects/#{PROJECT_ID}/stories?filter=type%3Afeature" => "features",
  "/projects/#{PROJECT_ID}/stories?filter=type%3Arelease" => "releases",
  "/projects/#{PROJECT_ID}/stories/#{RELEASE_ID}"         => "release",
  "/projects/#{PROJECT_ID}/stories?filter=type%3Achore"   => "chores",
  "/projects/#{PROJECT_ID}/stories?filter=type%3Abug"     => "bugs",
  "/projects/#{PROJECT_ID}/stories?filter=includedone%3Atrue" => "stories_with_done",
}.each do |(path, fixture)|
  FakeWeb.register_uri(:get, uri + path, :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "%s.xml" % fixture)))
end

FakeWeb.register_uri(:post, Regexp.new(uri + "/projects/#{PROJECT_ID}/stories"),
                            :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "create_story.xml")))
                            # http://www.pivotaltracker.com/services/v3/projects/153937/stories?story%5Bname%5D=Test&story%5Bproject_id%5D=153937&story%5Bestimate%5D=3

class User < Struct.new(:pivotal_tracker_api_key)
  pivotal_tracker_for :pivotal_tracker_api_key
end
