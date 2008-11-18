set :domain, '208.78.97.78'
set :port, '30000'
role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :application, "askito"
default_run_options[:pty] = true

set :repository, "git://github.com/askito/askito.git"
set :scm, "git"
set :user, "deploy"
set :branch, "master"

set :runner, user
set :ssh_options, { :forward_agent => true, :paranoid => false }

set :deploy_to, "/home/#{user}/public_html/#{application}"
set :rails_env, "production"

namespace :deploy do
  task :start do
    # nothing
    # overwrite default because we dont need method script/spin
  end
  
  task :stop do
    # nothing
  end
  
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{release_path}/tmp/restart.txt"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    # run "ln -nfs #{shared_path}/vendor/rails #{release_path}/vendor"
    run "ln -nfs #{shared_path}/vendor/gems #{release_path}/vendor"
  end
  
  desc "Run this after every successful deployment" 
  task :after_default do
    cleanup
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

