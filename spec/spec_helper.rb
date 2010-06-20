$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bundler'

Bundler.setup

require 'active_support/concern'
require 'active_record'
require 'active_model'
require 'active_record_stash'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
