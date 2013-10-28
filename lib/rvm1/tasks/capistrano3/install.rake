namespace :rvm1 do
  namespace :install do
    desc "Installs RVM 1.x user mode"
    task :rvm do
      on roles(:all) do
        execute :mkdir, "-p", "#{fetch(:tmp_dir)}/#{fetch(:application)}/"
        upload! File.expand_path("../../../../../script/install-rvm.sh", __FILE__), "#{fetch(:tmp_dir)}/#{fetch(:application)}/install-rvm.sh"
        execute :chmod, "+x", "#{fetch(:tmp_dir)}/#{fetch(:application)}/install-rvm.sh"
        execute "#{fetch(:tmp_dir)}/#{fetch(:application)}/install-rvm.sh"
      end
    end
  end
end
