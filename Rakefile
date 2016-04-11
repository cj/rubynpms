require './app/config/boot'
require 'opal/connect/rake_task'
require 'rspec/core/rake_task'

Opal::Connect::RakeTask.new('webpack')
RSpec::Core::RakeTask.new('rspec')

Dir["./app/tasks/**/*.rake"].each  { |rb| import rb }
