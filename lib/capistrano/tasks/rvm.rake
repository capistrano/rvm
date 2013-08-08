def rvm_path
  path = fetch(:rvm_custom_path)
  path ||= if fetch(:rvm_type) == "system"
    "/usr/local/rvm"
  else
    "~/.rvm"
  end

  path
end

map_bins = fetch(:rvm_bins) || %w{rake gem bundle ruby}

SSHKit.config.command_map = Hash.new do |hash, key|
  if map_bins.include?(key.to_s)
    hash[key] = "#{rvm_path}/bin/dump_#{key}"
  else
    hash[key] = key
  end
end

SSHKit.config.command_map[:rvm] = "#{rvm_path}/bin/rvm"

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

      execute :rvm, "wrapper #{rvm_ruby} #{fetch(:application)}"
    end
  end
end
