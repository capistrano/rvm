def bundler_loaded?
  Gem::Specification::find_all_by_name('capistrano-bundler').any?
end

SSHKit.config.command_map = Hash.new do |hash, key|
  if fetch(:rvm_map_bins).include?(key.to_s)
    hash[key] = "#{fetch(:rvm_path)}/bin/#{fetch(:application)}_#{key}"
  elsif key.to_s == "rvm"
    hash[key] = "#{fetch(:rvm_path)}/bin/rvm"
  else
    hash[key] = key
  end
end

namespace :deploy do
  before :starting, :hook_rvm do
    invoke :'rvm:check_config'
    invoke :'rvm:create_wrappers'
    invoke :'rvm:check'
  end
end

namespace :rvm do
  task :check_config do
    on roles(:all) do
      rvm_path = fetch(:rvm_custom_path)
      rvm_path ||= if fetch(:rvm_type) == :system
        "/usr/local/rvm"
      else
        "~/.rvm"
      end
      set :rvm_path, rvm_path

      rvm_ruby_version = fetch(:rvm_ruby_version)
      if rvm_ruby_version.nil?
        error "rvm: :rvm_ruby_version is not set"
        exit 1
      end
    end
  end

  task :check do
    on roles(:all) do
      execute :rvm, "version"
      execute :ruby, "--version"
    end
  end

  task :create_wrappers do
    on roles(:all) do
      execute :rvm, "wrapper #{fetch(:rvm_ruby_version)} #{fetch(:application)} #{fetch(:rvm_map_bins).join(" ")}"
    end
  end
end

namespace :load do
  task :defaults do
    set :rvm_map_bins, bundler_loaded? ? %w{rake gem bundle ruby} : %w{rake gem ruby}
    set :rvm_type, :user
  end
end
