require './app/config/boot'
require 'opal/connect/rake_task'

Opal::Connect::RakeTask.new('webpack')

Dir["./app/tasks/**/*.rake"].each  { |rb| import rb }
