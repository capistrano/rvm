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
    invoke :'rvm:create_wrappers'
    invoke :'rvm:check'
  end
end

namespace :rvm do
  task :check do
    on roles(:all) do
      execute :ruby, "--version"
      # if test "[ ! -d #{rvm_ruby_dir} ]"
        # error "rvm: #{fetch(:rvm_ruby)} is not installed or not found in #{rvm_ruby_dir}"
        # exit 1
      # end
    end
  end

  task :create_wrappers do
    on roles(:all) do
      rvm_ruby = fetch(:rvm_ruby)
      if rvm_ruby.nil?
        error "rvm: rvm_ruby is not set"
        exit 1
      end

      execute :rvm, "wrapper #{rvm_ruby} #{fetch(:application)} #{fetch(:rvm_map_bins).join(" ")}"
    end
  end
end

namespace :load do
  task :defaults do
    set :rvm_map_bins, bundler_loaded? ? %w{rake gem bundle ruby} : %w{rake gem ruby}
    set :rvm_type, :user

    rvm_path = fetch(:rvm_custom_path)
    rvm_path ||= if fetch(:rvm_type) == :system
      "/usr/local/rvm"
    else
      "~/.rvm"
    end

    set :rvm_path, rvm_path
  end
end
