namespace :rvm do
  desc "Prints the RVM and Ruby version on the target host"
  task :check do
    on roles(:all) do
      puts capture(:rvm, "version")
      puts capture(:rvm, "list")
      puts capture(:rvm, "current")
      within fetch(:release_path) do
        puts capture(:ruby, "--version || true")
      end
    end
  end
  before :check, "deploy:updating"

  desc "Runs the RVM hook - use it before any custom tasks if necessary"
  task :hook do
    on roles(:all) do
      execute :mkdir, "-p", "#{fetch(:tmp_dir)}/#{fetch(:application)}/"
      upload! File.expand_path("../../../../script/rvm-auto.sh", __FILE__), "#{fetch(:tmp_dir)}/#{fetch(:application)}/rvm-auto.sh"
      execute :chmod, "+x", "#{fetch(:tmp_dir)}/#{fetch(:application)}/rvm-auto.sh"
    end

    SSHKit.config.command_map[:rvm] = "#{fetch(:tmp_dir)}/#{fetch(:application)}/rvm-auto.sh rvm"

    rvm_prefix = "#{fetch(:tmp_dir)}/#{fetch(:application)}/rvm-auto.sh #{fetch(:rvm_ruby_version)}"
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
    set :rvm_ruby_version, "."
  end
end
