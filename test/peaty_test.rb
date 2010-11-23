require 'test/test_helper'

class PeatyTest < Test::Unit::TestCase
  
  def setup
    RestClient.log = Logger.new(File.join(File.dirname(__FILE__), 'test.log'))
    # All test's use TEST_TOKEN which is a valid API key""
    @user = User.new(TEST_TOKEN)
    @project_id = 125701
  end
  
  # Tests for Projects
  def test_user_can_fetch_a_project
    project = @user.pivotal_tracker_projects.find(@project_id)
    
    assert !project.nil?
    assert project.is_a?(Peaty::Project)
    assert_equal @project_id, project.id
  end
  
  def test_user_can_fetch_all_projects
    assert !@user.pivotal_tracker_projects.all.empty?
    assert @user.pivotal_tracker_projects.all.first.is_a?(Peaty::Project)
  end
  
  # Tests for Users
  def test_user_can_fetch_all_users_for_a_project
    assert !@user.pivotal_tracker_projects.find(@project_id).users.all.empty?
    assert @user.pivotal_tracker_projects.find(@project_id).users.contains(399324)
  end
  
  # Tests for Stories
  def test_user_can_fetch_all_stories_for_a_project
    assert !@user.pivotal_tracker_projects.find(@project_id).stories.all.empty?
    assert_equal @project_id, @user.pivotal_tracker_projects.find(@project_id).stories.first.project.id
  end
  
  def test_user_can_fetch_all_releases_for_a_project
    assert !@user.pivotal_tracker_projects.find(@project_id).releases.all.empty?
    assert_equal @project_id, @user.pivotal_tracker_projects.find(@project_id).releases.first.project.id
  end
  
  def test_user_can_fetch_all_releases_for_a_project_via_stories
    assert !@user.pivotal_tracker_projects.find(@project_id).stories(:type => :release).all.empty?
    assert_equal :release, @user.pivotal_tracker_projects.find(@project_id).releases.first.type
  end
  
  def test_user_can_fetch_all_bugs_for_a_project_via_stories
    assert !@user.pivotal_tracker_projects.find(@project_id).stories(:type => :bug).all.empty?
    assert_equal :bug, @user.pivotal_tracker_projects.find(@project_id).releases.first.type
  end
  
  def test_user_can_fetch_all_chores_for_a_project_via_stories
    assert !@user.pivotal_tracker_projects.find(@project_id).stories(:type => :chore).all.empty?
    assert_equal :chore, @user.pivotal_tracker_projects.find(@project_id).releases.first.type
  end
  
end
