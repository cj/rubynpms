# basic plugins
Sequel::Model.plugin :schema
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :nested_attributes
Sequel::Model.plugin :boolean_readers
Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :dirty

# Force all strings to be UTF8 encoded in a all model subclasses
Sequel::Model.plugin :force_encoding, 'UTF-8'

# Auto-manage created_at/updated_at fields
Sequel::Model.plugin :timestamps, :update_on_create => true

Sequel.extension :connection_validator
Sequel.extension :migration
Sequel.extension :core_extensions

module RubyNpms
  DB = Sequel.connect(DATABASE_URL) unless defined? DB
  DB.optimize_model_load = true

  if Sequel::Postgres.supports_streaming?
    DB.extension(:pg_streaming)
    DB.stream_all_queries = true
  end
end
