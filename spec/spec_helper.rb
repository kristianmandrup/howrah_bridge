require 'bundler'
Bundler.setup(:default, :test)

require 'rspec'
require 'rspec/autorun'

require 'activesupport'
require 'yaml' # for debugging! use .to_yaml
require 'nokogiri'

# require 'pdf-reader'
require 'prawn' 

require 'html_css_decorator'
require 'foxy_factory'

require 'howrah_processor'
require 'howrah'

require 'matchers/prawn_command'

RSpec.configure do |config|
  config.mock_with :mocha
  config.include(Matchers)  
end