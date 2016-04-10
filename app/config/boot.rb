Encoding.default_external = "UTF-8"

require_relative 'variables'

# load bundler
require 'bundler'
Bundler.setup :default, RACK_ENV

require 'rack/unreloader'

module RubyNpms; end

Unreloader = Rack::Unreloader.new(
  reload: RACK_ENV == 'development',
  subclasses: %w'Roda'
){RubyNpms::Server}

# standard gems
require 'rack/cors'
require 'rack/protection'
require 'redis-rack'
require 'roda'
require 'opal'
require 'opal-jquery'
require 'opal-connect'
# app specific gems
require 'aws-sdk'
require 'geminabox'

if %w'development test'.include? RACK_ENV
  require 'pry'
  require 'better_errors'
  require 'awesome_print'
end

# require configs
%w'aws connect roda_assets'.each { |config| require_relative config }

# require all app files
glob = './app/{components,plugins,models}/**/*.rb'
Dir[glob].each { |file| Unreloader.require file }

Unreloader.require './app/config/server.rb'
