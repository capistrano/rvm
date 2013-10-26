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


  task :init do
    on roles(:all) do
      upload! File.expand_path("../../../../script/rvm-auto.sh", __FILE__), "#{fetch(:tmp_dir)}/rvm-auto.sh"
      execute :chmod, "+x", "#{fetch(:tmp_dir)}/rvm-auto.sh"
    end
  end

end
