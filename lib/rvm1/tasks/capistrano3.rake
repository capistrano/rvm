SSHKit.config.command_map = Hash.new do |hash, key|
  if fetch(:rvm_map_bins).include?(key.to_s)
    hash[key] = "#{fetch(:tmp_dir)}/rvm-auto.sh #{fetch(:rvm_ruby_version)} #{key}"
  elsif key.to_s == "rvm"
    hash[key] = "#{fetch(:tmp_dir)}/rvm-auto.sh #{key}"
  else
    hash[key] = key
  end
end

namespace :deploy do
  after :starting, 'rvm1:hook'
end

namespace :rvm1 do
  desc "Runs the RVM1 hook - use it before any custom tasks if necessary"
  task :hook do
    unless fetch(:rvm1_hooked)
      invoke :'rvm1:init'
      set :rvm1_hooked, true
    end
  end

  desc "Prints the RVM1 and Ruby version on the target host"
  task :check do
    on roles(:all) do
      puts capture(:rvm, "version")
      puts capture(:rvm, "list")
      puts capture(:rvm, "current")
      puts capture(:ruby, "--version")
    end
  end
  before :check, 'rvm:hook'

  task :init do
    on roles(:all) do
      upload! File.expand_path("../../../../script/rvm-auto.sh", __FILE__), "#{fetch(:tmp_dir)}/rvm-auto.sh"
      execute :chmod, "+x", "#{fetch(:tmp_dir)}/rvm-auto.sh"
    end
  end

end

namespace :load do
  task :defaults do
    set :rvm1_ruby_string, "."
    set :rvm1_map_bins, %w{rake gem bundle ruby}
  end
end
