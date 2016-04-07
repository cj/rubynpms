Encoding.default_external = "UTF-8"

# need to figure out how to make the opalrb compiler work with require_relative
$:.unshift(Dir.pwd)

require 'app/config/variables'

require 'bundler'

RACK_ENV              = ENV.fetch('RACK_ENV')  { 'development' }
AWS_ACCESS_KEY_ID     = ENV.fetch('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = ENV.fetch('AWS_SECRET_ACCESS_KEY')
AWS_S3_BUCKET         = ENV.fetch('AWS_S3_BUCKET') { "ruby-npm-#{RACK_ENV}" }

Bundler.setup :default, RACK_ENV

require 'rack/unreloader'

module RubyNpm; end

Unreloader = Rack::Unreloader.new(
  reload: RACK_ENV == 'development',
  subclasses: %w'Roda Ohm'
){RubyNpm::Server}

require 'roda'
require 'opal'
require 'opal-jquery'
require 'opal-connect'

Opal.append_path Dir.pwd

Opal::Connect.setup do
  options[:plugins_path] = 'app/plugins'
  options[:plugins]      = [
    :server, :html, :dom, :events, :scope
  ]

  if RACK_ENV == 'development'
    options[:hot_reload] = {
      host: "http://local.sh",
      port: 8080,
    }
  end
end

glob = './app/{components,plugins,models}/**/*.rb'
Dir[glob].each { |file| Unreloader.require file }

assets_path = './public/assets/assets.json'

if RACK_ENV != 'development' && File.exist?(assets_path)
  assets             = JSON.parse File.read(assets_path)
  precompiled_assets = {}

  assets['main'].each do |key, value|
    precompiled_assets[key] = value.sub('main.', '').gsub(/\.[a-z]{2,3}$/, '')
  end

  File.write("#{Dir.pwd}/public/assets/precompiled.json", precompiled_assets.to_json)
end

Unreloader.require './app/config/server.rb'
