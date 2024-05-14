require 'spec_helper'

ONETIMESECRET_PASSWORD = 'SomeHardToGuessRandomCharacters'.freeze
ONETIMESECRET_VERSION = 'v0.12.1'.freeze
REDIS_PASSWORD = 'AnotherGoodPassword'.freeze

describe 'onetimesecret' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with default parameters' do
        let :params do
          {
            redis_password: REDIS_PASSWORD.to_s,
            secret: ONETIMESECRET_PASSWORD.to_s,
            version: ONETIMESECRET_VERSION.to_s,
          }
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
