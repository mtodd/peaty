require 'test_helper'

class PeatyTest < Test::Unit::TestCase
  
  def setup
    RestClient.log = Logger.new(File.join(File.dirname(__FILE__), 'test.log'))
    # All test's use TEST_TOKEN which is a valid API key""
    @user = User.new(TEST_TOKEN)
  end
  
  # Tests for Projects
  def test_user_can_fetch_a_project
    project = @user.pivotal_tracker_projects.find(PROJECT_ID)
    
    assert !project.nil?
    assert project.is_a?(Peaty::Project)
    assert_equal PROJECT_ID, project.id
  end
  
  def test_user_can_fetch_all_projects
    assert !@user.pivotal_tracker_projects.all.empty?
    assert @user.pivotal_tracker_projects.all.first.is_a?(Peaty::Project)
  end
  
  # Tests for Users
  def test_user_can_fetch_all_users_for_a_project
    project = @user.pivotal_tracker_projects.find(PROJECT_ID)
    assert !project.users.empty?
    # users include the account that created the project
    assert user = project.users.detect{ |u| u.name == project.account }
    assert_equal project.account, user.name
  end
  
  # Tests for Stories
  def test_user_can_fetch_all_stories_for_a_project
    assert !@user.pivotal_tracker_projects.find(PROJECT_ID).stories.all.empty?
    assert_equal PROJECT_ID, @user.pivotal_tracker_projects.find(PROJECT_ID).stories.first.project.id
  end
  
  def test_user_can_fetch_all_releases_for_a_project
    assert !@user.pivotal_tracker_projects.find(PROJECT_ID).releases.all.empty?
    assert_equal PROJECT_ID, @user.pivotal_tracker_projects.find(PROJECT_ID).releases.first.project.id
  end
  
  def test_user_can_fetch_all_releases_for_a_project_including_done
    projects = @user.pivotal_tracker_projects.find(PROJECT_ID).releases.all(:includedone => true)
    assert !projects.empty?
    assert_equal PROJECT_ID, projects.first.project.id
    assert_equal "accepted", projects.first.current_state
  end
  
  def test_user_can_fetch_all_releases_for_a_project_via_stories
    assert !@user.pivotal_tracker_projects.find(PROJECT_ID).stories(:type => :release).all.empty?
    assert_equal :release, @user.pivotal_tracker_projects.find(PROJECT_ID).releases.first.story_type
  end
  
  def test_user_can_fetch_all_bugs_for_a_project_via_stories
    assert !@user.pivotal_tracker_projects.find(PROJECT_ID).stories(:type => :bug).all.empty?
    assert_equal :bug, @user.pivotal_tracker_projects.find(PROJECT_ID).bugs.first.story_type
  end
  
  def test_user_can_fetch_all_chores_for_a_project_via_stories
    assert !@user.pivotal_tracker_projects.find(PROJECT_ID).stories(:type => :chore).all.empty?
    assert_equal :chore, @user.pivotal_tracker_projects.find(PROJECT_ID).chores.first.story_type
  end
  
  # Tests for Iterations
  def test_user_can_fetch_a_projects_iterations
    project = @user.pivotal_tracker_projects.find(PROJECT_ID)
    assert !project.iterations.all.empty?
    assert iteration = project.iterations.first
    assert !iteration.stories.empty?
    assert_equal project.id, iteration.stories.first.project.id
  end
  
end
