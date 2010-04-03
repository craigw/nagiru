require 'fileutils'
require 'ftools'
require File.join(File.dirname(__FILE__), 'profile')

module Nagiru
  class ProfileManager
    def each(&block)
      profiles.each(&block)
    end
    include Enumerable

    def remove(profile_name)
      ::FileUtils.rm_rf(File.join(profile_base, profile_name))
    end

    def create(profile_name)
      profile_dir = File.join(profile_base, profile_name)
      File.makedirs(profile_dir)
      nagios_cfg = File.join(profile_dir, 'nagios.cfg')
      File.open(nagios_cfg, 'w') { |config|
        config.puts "TODO"
      }
    end

    private
    def profile_base
      root = File.join(File.dirname(__FILE__), '..', '..')
      File.join(root, 'nagiru', 'profiles')
    end

    def profiles
      Dir[File.join(profile_base, '*')].map { |profile_dir|
        name = File.basename(profile_dir)
        Nagiru::Profile.new(:name => name)
      }
    end
  end
end
