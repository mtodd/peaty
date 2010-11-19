require 'test_helper'

require 'rest_client'
require 'nokogiri'

class PeatyTest < Test::Unit::TestCase
  
  def setup
    RestClient.log = Logger.new(File.join(File.dirname(__FILE__), 'test.log'))
    @user = User.new(TEST_TOKEN)
  end
  
  def test_user_can_fetch_a_project_with_valid_api_key
    project_id = 125701
    project = @user.pivotal_tracker_projects.find(project_id)
    
    assert !project.nil?
    assert project.is_a?(Peaty::Project)
    assert_equal project_id, project.id
  end
  
  def test_user_can_fetch_all_projects_with_valid_api_key
    assert !@user.pivotal_tracker_projects.all.empty?
    assert @user.pivotal_tracker_projects.all.first.is_a?(Peaty::Project)
  end
  
  def test_user_can_fetch_all_stories_for_a_project_with_valid_api_key
    project_id = 125701
    assert !@user.pivotal_tracker_projects.find(project_id).stories.all.empty?
    assert_equal project_id, @user.pivotal_tracker_projects.find(project_id).stories.first.project.id
  end
  
end
