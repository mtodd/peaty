require 'pathname'
require 'logger'

require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/core_ext/benchmark'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/object/blank'

require 'rest-client'
require 'nokogiri'
require 'xml_to_json'
require 'yajl/json_gem'

$:.unshift Pathname.new(__FILE__).dirname
require 'peaty/integration'
require 'peaty/proxy'
require 'peaty/base'
require 'peaty/project'
require 'peaty/iteration'
require 'peaty/story'
require 'peaty/user'

module Peaty
  
  VERSION = "0.4.0"
  
  def self.root
    @root ||= Pathname.new(__FILE__).dirname.parent
  end
  
end
