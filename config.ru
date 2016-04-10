require './app/config/boot'

RACK_ENV != 'development' ? run(RubyNpms::Server) : Opal::Connect.run(self, Unreloader)
