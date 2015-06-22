# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'rails'
set :repo_url, 'git@bitbucket.org:nkj20932/express.git'

# $ DEPLOY_PATH=staging cap production deploy
if ENV["DEPLOY_PATH"]
  @folder = "staging"
  set :deploy_to, "/var/www/#{@folder}"
else
  @folder = "rails"
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

role :web, %w{motionex@107.170.207.41}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  user = "motionex"
  server = "107.170.207.41"
  local_path = "cd ~/projects/express;"
  path_prefix_public_no_cd = "/var/www/#{@folder}/current/public"
  path_prefix = "cd /var/www/#{@folder}/current;"
  path_prefix_public = "cd /var/www/#{@folder}/current/public;"

  task :bundle do
    on roles(:web) do
      execute "#{path_prefix}bundle install"
    end
  end

  task :migrate do
    on roles(:web) do
      execute "#{path_prefix}rake db:migrate RAILS_ENV=production"
    end
  end

  task :precompile do
    on roles(:web) do
      # execute "#{path_prefix}rake assets:clean"
      # execute "#{path_prefix}rake assets:precompile"
      execute("#{path_prefix_public}rm -rf assets")
      %x("#{local_path}rake assets:precompile")
      %x("#{local_path}scp -r public/assets #{user}@#{server}:#{path_prefix_public_no_cd}/assets")
      %x("#{local_path}rm -rf public/assets")
    end
  end

  task :symlink do
    on roles(:web) do
      execute "#{path_prefix_public}ln -s /var/www/#{@folder}/shared/public/wp-content"
    end
  end

  task :staging_robot do
    on roles(:web) do
      execute "#{path_prefix_public}rm robot.txt"
      execute "#{path_prefix_public}ln -s /var/www/#{@folder}/shared/public/robot.txt"
    end
  end

  task :server_restart do
    on roles(:web) do
      # execute "service nginx restart"
      execute! :sudo, :service, :nginx, :restart
    end
  end

  after :deploy, "deploy:bundle"
  after :deploy, "deploy:migrate"
  after :deploy, "deploy:symlink"
  after :deploy, "deploy:precompile"
  after :deploy, "deploy:staging_robot" if ENV["DEPLOY_PATH"] == "staging"
  after :deploy, "deploy:server_restart"
end
