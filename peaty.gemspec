# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{peaty}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Todd"]
  s.date = %q{2010-12-01}
  s.description = %q{Just another Pivotal Tracker API Implementation}
  s.email = %q{chiology@gmail.com}
  s.files = [
    "Gemfile",
    "Gemfile.lock",
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
    "lib/peaty/user.rb",
    "peaty.gemspec",
    "test/.gitignore",
    "test/fixtures/bugs.xml",
    "test/fixtures/chores.xml",
    "test/fixtures/features.xml",
    "test/fixtures/iterations.xml",
    "test/fixtures/iterations_done.xml",
    "test/fixtures/project.xml",
    "test/fixtures/projects.xml",
    "test/fixtures/release.xml",
    "test/fixtures/releases.xml",
    "test/fixtures/stories.xml",
    "test/fixtures/stories_with_done.xml",
    "test/fixtures/story.xml",
    "test/peaty_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/mtodd/peaty}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Pivotal Tracker API Implementation}
  s.test_files = [
    "test/peaty_test.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0.1"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri-happymapper>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<xml_to_json>, ["= 0.0.1"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_development_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_development_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["= 2.1.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.0.pre6"])
      s.add_development_dependency(%q<rails_code_qa>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, ["= 1.4.3.1"])
      s.add_development_dependency(%q<yajl-ruby>, ["= 0.7.8"])
      s.add_development_dependency(%q<activesupport>, ["~> 3.0.1"])
      s.add_development_dependency(%q<builder>, ["= 2.1.2"])
      s.add_development_dependency(%q<rspec>, ["= 2.1.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.0.pre6"])
      s.add_development_dependency(%q<rails_code_qa>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, ["~> 3.0.1"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<nokogiri-happymapper>, [">= 0"])
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<xml_to_json>, ["= 0.0.1"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<rspec>, ["= 2.1.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre6"])
      s.add_dependency(%q<rails_code_qa>, [">= 0"])
      s.add_dependency(%q<nokogiri>, ["= 1.4.3.1"])
      s.add_dependency(%q<yajl-ruby>, ["= 0.7.8"])
      s.add_dependency(%q<activesupport>, ["~> 3.0.1"])
      s.add_dependency(%q<builder>, ["= 2.1.2"])
      s.add_dependency(%q<rspec>, ["= 2.1.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre6"])
      s.add_dependency(%q<rails_code_qa>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 3.0.1"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<nokogiri-happymapper>, [">= 0"])
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<xml_to_json>, ["= 0.0.1"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<rspec>, ["= 2.1.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre6"])
    s.add_dependency(%q<rails_code_qa>, [">= 0"])
    s.add_dependency(%q<nokogiri>, ["= 1.4.3.1"])
    s.add_dependency(%q<yajl-ruby>, ["= 0.7.8"])
    s.add_dependency(%q<activesupport>, ["~> 3.0.1"])
    s.add_dependency(%q<builder>, ["= 2.1.2"])
    s.add_dependency(%q<rspec>, ["= 2.1.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.0.pre6"])
    s.add_dependency(%q<rails_code_qa>, [">= 0"])
  end
end

