# frozen_string_literal: true

require 'spec_helper'

enforce_options = [true, false]

describe 'cis_security_hardening::rules::cups' do
  on_supported_os.each do |os, os_facts|
    enforce_options.each do |enforce|
      context "on #{os}" do
        let(:facts) { os_facts }
        let(:params) do
          {
            'enforce' => enforce,
          }
        end

        it {
          is_expected.to compile

          if enforce
            if os_facts[:os]['name'].casecmp('ubuntu').zero? || os_facts[:os]['name'].casecmp('sles').zero?

              if os_facts[:os]['family'].casecmp('suse').zero?
                is_expected.to contain_package('cups')
                  .with(
                    'ensure' => 'absent',
                  )
              else
                is_expected.to contain_package('cups')
                  .with(
                    'ensure' => 'purged',
                  )
              end

            elsif os_facts[:os]['name'].casecmp('rocky').zero? || os_facts[:os]['name'].casecmp('almalinux').zero?
              is_expected.to contain_package('cups')
                .with(
                  'ensure' => 'purged',
                )
            elsif os_facts[:os]['name'].casecmp('debian').zero?
              if os_facts[:os]['release']['major'] > '10'
                is_expected.to contain_package('cups')
                .with(
                  'ensure' => 'purged',
                )
              else
                is_expected.to contain_service('cups')
                .with(
                  'ensure' => 'stopped',
                  'enable' => false,
                )
              end
            else
              is_expected.to contain_service('cups')
                .with(
                  'ensure' => 'stopped',
                  'enable' => false,
                )
            end

          else
            is_expected.not_to contain_service('cups')
            is_expected.not_to contain_package('cups')
          end
        }
      end
    end
  end
end
