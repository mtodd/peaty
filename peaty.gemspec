# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "peaty"
  s.version = "0.6.0.beta1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Todd", "Andy Lindeman"]
  s.date = "2011-10-18"
  s.description = "Just another Pivotal Tracker API Implementation"
  s.email = ["chiology@gmail.com", "alindeman@gmail.com"]
  s.files = [
    "Gemfile",
    "Rakefile",
    "Readme.textile",
    "VERSION",
    "lib/peaty.rb",
    "lib/peaty/base.rb",
    "lib/peaty/integration.rb",
    "lib/peaty/iteration.rb",
    "lib/peaty/project.rb",
    "lib/peaty/proxy.rb",
    "lib/peaty/story.rb",
    "lib/peaty/task.rb",
    "lib/peaty/user.rb",
    "peaty.gemspec",
    "test/.gitignore",
    "test/fixtures/bugs.xml",
    "test/fixtures/chores.xml",
    "test/fixtures/create_story.xml",
    "test/fixtures/create_story_error.xml",
    "test/fixtures/create_task.xml",
    "test/fixtures/features.xml",
    "test/fixtures/iterations.xml",
    "test/fixtures/iterations_done.xml",
    "test/fixtures/move_after.xml",
    "test/fixtures/move_before.xml",
    "test/fixtures/project.xml",
    "test/fixtures/projects.xml",
    "test/fixtures/release.xml",
    "test/fixtures/releases.xml",
    "test/fixtures/stories.xml",
    "test/fixtures/stories_with_done.xml",
    "test/fixtures/story.xml",
    "test/fixtures/task.xml",
    "test/fixtures/tasks.xml",
    "test/peaty_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = "http://github.com/mtodd/peaty"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Pivotal Tracker API Implementation"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.4"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri-happymapper>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<xml_to_json>, ["~> 0.0.2"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_development_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_development_dependency(%q<rails_code_qa>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.0.4"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<nokogiri-happymapper>, [">= 0"])
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<xml_to_json>, ["~> 0.0.2"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_dependency(%q<rails_code_qa>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.0.4"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<nokogiri-happymapper>, [">= 0"])
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<xml_to_json>, ["~> 0.0.2"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
    s.add_dependency(%q<rails_code_qa>, [">= 0"])
  end
end

