require 'spec_helper'

ONETIMESECRET_PASSWORD = 'SomeHardToGuessRandomCharacters'.freeze
ONETIMESECRET_VERSION = 'v0.13.0-RC7'.freeze
ONETIMESECRET_VERSION_HASH = 'a46fdeb2274bb528516505cec8ffb3568dd47c1c'.freeze
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
        it { is_expected.to contain_file('/etc/systemd/system/onetimesecret.service').with_content(%r{WorkingDirectory=/opt/onetimesecret-0.13.0-RC7}) }
      end

      context 'when setting version to a commit hash' do
        let :params do
          {
            redis_password: REDIS_PASSWORD.to_s,
            secret: ONETIMESECRET_PASSWORD.to_s,
            version: ONETIMESECRET_VERSION_HASH.to_s,
          }
        end
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/systemd/system/onetimesecret.service').with_content(%r{WorkingDirectory=/opt/onetimesecret-#{ONETIMESECRET_VERSION_HASH}}) }
      end
    end
  end
end
