RVM_SYSTEM_PATH = "/usr/local/rvm"
RVM_USER_PATH = "~/.rvm"

def bundler_loaded?
  Gem::Specification::find_all_by_name('capistrano-bundler').any?
end

SSHKit.config.command_map = Hash.new do |hash, key|
  if fetch(:rvm_map_bins).include?(key.to_s)
    hash[key] = "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do #{key}"
  elsif key.to_s == "rvm"
    hash[key] = "#{fetch(:rvm_path)}/bin/rvm"
  else
    hash[key] = key
  end
end

namespace :rvm do
  desc "Runs the RVM hook - use it before any custom tasks if necessary"
  task :hook do
    unless fetch(:rvm_hooked)
      invoke :'rvm:init'
      set :rvm_hooked, true
    end
  end

  desc "Prints the RVM and Ruby version on the target host"
  task :check do
    on roles(:all) do
      puts capture(:rvm, "version")
      puts capture(:rvm, "current")
      puts capture(:ruby, "--version")
    end
  end
  before :check, 'rvm:hook'

  task :init do
    on roles(:all) do
      rvm_path = fetch(:rvm_custom_path)
      rvm_path ||= case fetch(:rvm_type)
      when :auto
        if test("[ -d #{RVM_USER_PATH} ]")
          RVM_USER_PATH
        elsif test("[ -d #{RVM_SYSTEM_PATH} ]")
          RVM_SYSTEM_PATH
        else
          RVM_USER_PATH
        end
      when :system, :mixed
        RVM_SYSTEM_PATH
      else # :user
        RVM_USER_PATH
      end
      set :rvm_path, rvm_path

      rvm_ruby_version = fetch(:rvm_ruby_version)
      rvm_ruby_version ||= capture(:rvm, "current")
      set :rvm_ruby_version, rvm_ruby_version
    end
  end

end

namespace :load do
  task :defaults do
    set :rvm_map_bins, bundler_loaded? ? %w{bundle gem rake ruby} : %w{gem rake ruby}
    set :rvm_type, :auto
  end
end

namespace :deploy do
  after :starting, 'rvm:hook'
end
