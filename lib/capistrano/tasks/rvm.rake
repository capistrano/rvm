RVM_SYSTEM_PATH = "/usr/share/rvm"
RVM_OLD_SYSTEM_PATH = "/usr/local/rvm"
RVM_USER_PATH = "~/.rvm"

namespace :rvm do
  desc "Prints the RVM and Ruby version on the target host"
  task :check do
    on roles(fetch(:rvm_roles, :all)) do
      if fetch(:log_level) == :debug
        puts capture(:rvm, "version")
        puts capture(:rvm, "current")
        puts capture(:ruby, "--version")
      end
    end
  end

  task :hook do
    on roles(fetch(:rvm_roles, :all)) do
      rvm_path = fetch(:rvm_custom_path)
      unless rvm_path
        rvm_type = fetch(:rvm_type)
        if rvm_type == :auto
          [RVM_USER_PATH,
            RVM_SYSTEM_PATH,
            RVM_OLD_SYSTEM_PATH].each do |pathtotest|
            if test("[ -d #{pathtotest} ]")
              rvm_path = pathtotest
              break
            end
          end
        elsif [:system,:mixed].include?(rvm_type)                    
          rvm_path = RVM_SYSTEM_PATH
        else # :user
          rvm_path = RVM_USER_PATH
        end
      end

      if test("[ ! -d #{rvm_path} ]")
        puts <<EOF
################################################################################

capistrano-rvm config:

RVM path was derived as #{rvm_path}, but that is not found.   Things won't work.

You may want to try adding

set :rvm_type, :auto

To your stage, which will search a set of likely candidates.

You can also set it specifically with:

set :rvm_path, '/a/path/to/rvm'

You should be aware that when installing rvm in system mode, the default path
changed from

/usr/local/rvm

to

/usr/share/rvm

starting with

https://github.com/rvm/rvm/issues/2456

################################################################################

EOF
        raise "RVM Path #{rvm_path} does not exist.  See longer error description above"
      end
      set :rvm_path, rvm_path
    end

    SSHKit.config.command_map[:rvm] = "#{fetch(:rvm_path)}/bin/rvm"

    rvm_prefix = "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do"
    fetch(:rvm_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(rvm_prefix)
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'rvm:hook'
  after stage, 'rvm:check'
end

namespace :load do
  task :defaults do
    set :rvm_map_bins, %w{gem rake ruby bundle}
    set :rvm_type, :auto
    set :rvm_ruby_version, "default"
  end
end
