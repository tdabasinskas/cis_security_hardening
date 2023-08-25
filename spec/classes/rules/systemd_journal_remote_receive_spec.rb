# frozen_string_literal: true

require 'spec_helper'

enforce_options = [true, false]

describe 'cis_security_hardening::rules::systemd_journal_remote_receive' do
  enforce_options.each do |enforce|
    context "on Ubuntu with enforce #{enforce}" do
      let(:facts) do
        {
          os => {
            'architecture' => 'x86_64',
            'family' => 'Debian',
            'name' => 'Ubuntu',
            'release' => {
              'major' => '22.04',
            }
          }
        }
      end
      let(:params) do
        {
          'enforce' => enforce,
        }
      end

      it {
        is_expected.to compile.with_all_deps

        if enforce
          is_expected.to contain_service('systemd-journal-remote.socket')
            .with(
              'ensure' => 'running',
              'enable' => true,
            )
        else
          is_expected.not_to contain_service('systemd-journal-remote.socket')
        end
      }
    end
  end
end
