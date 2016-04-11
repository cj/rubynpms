require './app/config/boot'

RSpec.configure do |config|
  config.filter_run_excluding :slow
  config.color = true

  if RUBY_ENGINE != 'opal'
    # http://sequel.jeremyevans.net/rdoc/files/doc/testing_rdoc.html
    config.around(:all) do |example|
      Sequel.transaction RubyNpms::DB, rollback: :always do
        example.run
      end
    end

    config.around(:each) do |example|
      Sequel.transaction(RubyNpms::DB, rollback: :always, savepoint: true, auto_savepoint: true) do
        example.run
      end
    end
  end
end
