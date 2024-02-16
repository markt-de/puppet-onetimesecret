require 'spec_helper_acceptance'

describe 'onetimesecret' do
  let(:onetimesecret_password) { 'SomeHardToGuessRandomCharacters' }
  let(:onetimesecret_version) { 'v0.12.0' }
  let(:redis_password) { 'AnotherGoodPassword' }

  context 'with default parameters' do
    let(:pp) do
      %(class { 'onetimesecret':
        redis_password => '#{redis_password}',
        secret         => '#{onetimesecret_password}',
        version        => '#{onetimesecret_version}',
      })
    end

    it { apply_manifest(pp, catch_failures: true) }
  end
end
