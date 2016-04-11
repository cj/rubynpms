# Load environment variables
%W{.env .env.#{ENV['RACK_ENV']}}.each do |file|
  File.foreach file do |line|
    key, value = line.split "=", 2; ENV[key] = value.gsub('\n', '').strip
  end if File.file? file
end

RACK_ENV              = ENV.fetch('RACK_ENV')  { 'development' }
AWS_ACCESS_KEY_ID     = ENV.fetch('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = ENV.fetch('AWS_SECRET_ACCESS_KEY')
AWS_S3_BUCKET         = ENV.fetch('AWS_S3_BUCKET') { "ruby-npm-#{RACK_ENV}" }
SITE_URL              = ENV.fetch('SITE_URL')
DATABASE_URL          = ENV.fetch('DATABASE_URL')
