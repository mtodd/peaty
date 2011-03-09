require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "peaty"
  gem.homepage = "http://github.com/mtodd/peaty"
  gem.license = "MIT"
  gem.summary = %Q{Pivotal Tracker API Implementation}
  gem.description = %Q{Just another Pivotal Tracker API Implementation}
  gem.email = "chiology@gmail.com"
  gem.authors = ["Matt Todd"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'

Rake::TestTask.new("test") do |t|
  t.libs << "test"
  t.pattern = 'test/*_test.rb'
  t.verbose = true
  t.warning = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "xml_to_json #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end