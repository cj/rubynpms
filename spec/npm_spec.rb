require 'spec_helper'

describe 'npm' do
  context 'searching' do
    before do
      versions = %w'1.1 2.2 3.3'.map { |version| RubyNpms::Models::Version.create(number: version) }
      RubyNpms::Models::Npm.create(name: 'jquery').versions = versions
      RubyNpms::Models::Npm.create(name: 'jquery-something').versions = versions
    end

    it 'should find by wildcard' do
      search = RubyNpms::Models::Npm.redis.call('scan', '0', 'MATCH', '*name:jq*')
      expect(npm.name).to eq 'jquery'
    end
  end unless RUBY_ENGINE == 'opal'
end
