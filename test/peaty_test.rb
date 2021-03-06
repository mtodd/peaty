require 'test_helper'

class PeatyTest < Test::Unit::TestCase
  
  def setup
    super

    RestClient.log = Logger.new(File.join(File.dirname(__FILE__), 'test.log'))
    # All test's use TEST_TOKEN which is a valid API key""
    @user = User.new(TEST_TOKEN)
  end

  def teardown
    FakeWeb.clean_registry
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
  
  def test_user_can_fetch_all_releases_for_a_project_including_accepted_for_the_current_iteration
    releases = @user.pivotal_tracker_projects.find(PROJECT_ID).releases.all
    assert !releases.empty?
    assert_equal PROJECT_ID, releases.first.project.id
    assert_equal "accepted", releases.first.current_state
  end
  
  def test_user_can_fetch_all_stories_for_a_project_even_from_previous_iterations
    project = @user.pivotal_tracker_projects.find(PROJECT_ID)
    stories = project.stories.all(:includedone => true)
    assert !stories.empty?
    assert stories.size > project.stories.all.size # exclude done
    
    story = stories.first
    assert_equal PROJECT_ID, story.project.id
    assert_equal "accepted", story.current_state
    
    done = project.iterations.find(:done)
    assert done.stories.any?{ |s| s.id == story.id }
  end

  def test_user_can_move_stories_after_other_stories
    project = @user.pivotal_tracker_projects.find(PROJECT_ID)
    stories = project.stories.all

    story1, story2 = stories[0], stories[1]

    moves_path = "/projects/#{PROJECT_ID}/stories/#{story1.id}/moves?move\[move\]=after&move\[target\]=#{story2.id}"
    FakeWeb.register_uri(:post,
                         PT_BASE_URI + moves_path,
                         :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "move_after.xml")))

    story1.move(:after => story2)

    assert_equal 'POST', FakeWeb.last_request.method
    assert_equal PT_BASE_PATH + moves_path, FakeWeb.last_request.path
  end

  def test_user_can_move_stories_before_other_stories
    project = @user.pivotal_tracker_projects.find(PROJECT_ID)
    stories = project.stories.all

    story1, story2 = stories[0], stories[1]

    moves_path = "/projects/#{PROJECT_ID}/stories/#{story2.id}/moves?move\[move\]=before&move\[target\]=#{story1.id}"
    FakeWeb.register_uri(:post,
                         PT_BASE_URI + moves_path,
                         :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "move_before.xml")))

    story2.move(:before => story1)

    assert_equal 'POST', FakeWeb.last_request.method
    assert_equal PT_BASE_PATH + moves_path, FakeWeb.last_request.path
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
  
  def test_user_can_create_a_new_story_for_a_project
    FakeWeb.register_uri(:post, Regexp.new(PT_BASE_URI + "/projects/#{PROJECT_ID}/stories"),
                                :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "create_story.xml")))
                                # http://www.pivotaltracker.com/services/v3/projects/153937/stories?story%5Bname%5D=Test&story%5Bproject_id%5D=153937&story%5Bestimate%5D=3
    
    story = @user.pivotal_tracker_projects.find(PROJECT_ID).stories.build(:name => name = "Test")
    assert story.is_a?(Peaty::Story)
    assert story.new_record?
    assert_equal PROJECT_ID, story.project_id
    assert_equal name, story.name
    
    story.estimate = 3
    assert story.save
    assert !story.new_record?
  end
  
  def test_user_can_get_error_messages_when_trying_to_create_a_new_story_for_a_project_that_fails
    FakeWeb.register_uri(:post, Regexp.new(PT_BASE_URI + "/projects/#{PROJECT_ID}/stories"),
                                :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "create_story_error.xml")),
                                :status => 422)
    
    story = @user.pivotal_tracker_projects.find(PROJECT_ID).stories.build(:title => "Title Doesn't Exist")
    assert !story.save
    assert story.new_record?
    assert_equal "unknown attribute: title", story.error
  end
  
  # Tests for Iterations
  def test_user_can_fetch_a_projects_iterations
    project = @user.pivotal_tracker_projects.find(PROJECT_ID)
    assert !project.iterations.all.empty?
    assert iteration = project.iterations.first
    assert !iteration.stories.empty?
    assert_equal project.id, iteration.stories.first.project.id
  end

  # Tests for Tasks
  def test_user_can_fetch_tasks
    FakeWeb.register_uri(:get, Regexp.new(PT_BASE_URI + "/projects/#{PROJECT_ID}/stories/#{STORY_ID}/tasks"),
                               :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "tasks.xml")))

    tasks = @user.pivotal_tracker_projects.find(PROJECT_ID).
                  stories.find(STORY_ID).
                  tasks

    assert_equal 1, tasks.all.length
    assert_equal 1234, tasks.first.id
    assert_equal "find shields", tasks.first.description
  end

  def test_user_can_fetch_task
    FakeWeb.register_uri(:get, Regexp.new(PT_BASE_URI + "/projects/#{PROJECT_ID}/stories/#{STORY_ID}/tasks/#{TASK_ID}"),
                               :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "task.xml")))

    task = @user.pivotal_tracker_projects.find(PROJECT_ID).
                 stories.find(STORY_ID).
                 tasks.find(TASK_ID)

    assert_equal 1234, task.id
    assert_equal "find shields", task.description
  end

  def test_user_can_create_task
    FakeWeb.register_uri(:post, Regexp.new(PT_BASE_URI + "/projects/#{PROJECT_ID}/stories/#{STORY_ID}/tasks"),
                                :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "create_task.xml")))

    task = @user.pivotal_tracker_projects.find(PROJECT_ID).
                 stories.find(STORY_ID).
                 tasks.build(:description => "clean shields")

    assert task.save
    assert_equal 1234, task.id
    assert_equal "clean shields", task.description
  end
end
