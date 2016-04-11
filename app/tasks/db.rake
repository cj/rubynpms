namespace :db do

  require 'sequel'
  Sequel.extension(:migration)
  MIGRATIONS_PATH = 'app/db/migrations'
  DB = RubyNpms::DB

  def db_conn_env
    DATABASE_URL
  end

  def db_conn_url
    db = split_db_url(db_conn_env)
    db_conn = "postgres://#{db[:user]}#{db[:pass] ? ":#{db[:pass]}" : ''}@#{db[:host]}"
  end

  def split_db_url(url)
    user, pass, host, database = url.scan(/postgres:\/\/(.+?)(?:(|:(.+?)))@(.+?)\/(.+?)$/).first
    data = {
      user:     user,
      pass:     pass.empty?? false : pass,
      host:     host,
      database: database
    }
  end

  def db_migrate(version = db_migrations.last)
    puts "Migrating database to version #{version}"
    Sequel::Migrator.run(DB, MIGRATIONS_PATH, target: version.to_i)
  end

  def db_migrated?(version, schema = :sequel)
    db_versions(schema).include?(version.to_s)
  end

  def db_versions(schema = :sequel)
    if schema == :sequel
      DB[:schema_migrations].order(:filename).select_map(:filename)
    elsif schema == :rails
      DB[:schema_migrations].order(:version).select_map(:version)
    else
      []
    end
  end

  def db_migrations
    Dir[MIGRATIONS_PATH + "/*.rb"]
      .map { |f| File.basename(f) }
      .sort
  end

  def db_schema(object)
    Hash[DB.schema(object)]
  rescue Sequel::DatabaseError
    nil
  end

  desc 'Seed the database with application required data'
  task seed: :environment do
    load 'db/seeds.rb'
  end

  desc "Prints current schema version"
  task :version => :environment do
    puts "Current Schema Version: #{db_versions(:sequel).last}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate, [:version] => :environment do |t, args|
    db_migrate(args[:version] || db_migrations.last)
    Rake::Task['db:version'].execute
  end

  desc "Perform rollback to specified target or previous version as default"
  task :rollback, [:version] => :environment do |t, args|
    version = args[:version] || db_versions(:sequel)[-2]
    db_migrate(version)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration) only on local environment"
  task :reset => :environment do
    if (ENV["RACK_ENV"]) == "production"
      abort "You can't run this rake on production environment"
    end

    db_migrate(0)
    db_migrate(db_migrations.last)
    Rake::Task['db:version'].execute
  end
end
