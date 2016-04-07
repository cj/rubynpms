require './app/config/boot'

if RACK_ENV != 'development'
  run RubyNpm::Server
else
  Opal::Connect.run self, Unreloader
end
