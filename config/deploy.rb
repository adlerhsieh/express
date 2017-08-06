require 'yaml'

config_map = YAML.load_file(File.expand_path("../deploy.yml", __FILE__))

# config valid only for current version of Capistrano
# lock '3.4.0'

set :application, 'express'
set :repo_url, 'git@github.com:adlerhsieh/express.git'
set :deploy_to, '/home/ubuntu/apps/express'
set :rbenv_ruby, File.read(File.expand_path("../../.ruby-version", __FILE__)).strip

@folder = "express"

# $ DEPLOY_PATH=staging cap production deploy
# if ENV["DEPLOY_PATH"]
#   @folder = "staging"
#   # set :deploy_to, "/home/ubuntu/apps/#{@folder}"
#   set :deploy_to, "/home/ubuntu/apps/#{@folder}"
# else
#   @folder = "rails"
# end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /home/ubuntu/apps/my_app_name
# set :deploy_to, '/home/ubuntu/apps/my_app_name'

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

# role :web, %w{motionex@107.170.207.41}
role :web, config_map["production"]["role"]["web"]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  # server                   = "107.170.207.41"
  # server                   = ""
  # local_path               = "cd ~/projects/express;"
  # user                     = YAML.load_file(File.expand_path("../application.yml",__FILE__))["development"]["remote_user"]
  # local_path_config        = "cd ~/projects/express/config;"
  # local_path_public        = "cd ~/projects/express/public;"
  # path_prefix_public_no_cd = "/home/ubuntu/apps/#{@folder}/current/public"
  # path_prefix_config_no_cd = "/home/ubuntu/apps/#{@folder}/current/config"
  # path_prefix              = "cd /home/ubuntu/apps/#{@folder}/current;"
  # path_prefix_public       = "cd /home/ubuntu/apps/#{@folder}/current/public;"
  # path_certs               = "cd /home/ubuntu/apps/#{@folder}/current/certs;"
  #
  # task :bundle do
  #   on roles(:web) do
  #     execute "#{path_prefix}bundle install"
  #   end
  # end
  #
  # task :migrate do
  #   on roles(:web) do
  #     execute "#{path_prefix}bundle exec rake db:migrate RAILS_ENV=production"
  #   end
  # end
  #
  # task :seed do
  #   on roles(:web) do
  #     execute "#{path_prefix}bundle exec rake db:seed RAILS_ENV=production"
  #   end
  # end
  #
  # task :precompile do
  #   on roles(:web) do
  #     execute("#{path_prefix_public}rm -rf assets")
  #     run_locally do
  #       execute("#{local_path}bundle exec rake assets:precompile RAILS_ENV=production")
  #       execute("#{local_path_public}tar -jcvf assets.tar.bz2 assets")
  #       execute("#{local_path_public}scp assets.tar.bz2 #{user}@#{server}:#{path_prefix_public_no_cd}/assets.tar.bz2")
  #       execute("#{local_path_public}rm assets.tar.bz2")
  #       execute("#{local_path}rm -rf public/assets")
  #     end
  #     execute("#{path_prefix_public}tar -jxvf assets.tar.bz2")
  #     execute("#{path_prefix_public}rm assets.tar.bz2")
  #   end
  # end
  #
  #
  # task :symlink do
  #   on roles(:web) do
  #     @folder = ENV["DEPLOY_PATH"] == "staging" ? "staging" : "rails"
  #     execute "#{path_prefix_public}ln -s /home/ubuntu/apps/#{@folder}/shared/public/wp-content"
  #     execute "cd /home/ubuntu/apps/#{@folder}/current/config;ln -s /home/ubuntu/apps/#{@folder}/shared/config/application.yml"
  #     execute "cd /home/ubuntu/apps/#{@folder}/current;mkdir certs"
  #     execute "#{path_certs}ln -s /home/ubuntu/apps/#{@folder}/shared/config/certs/paypal_cert_#{@folder}.pem"
  #     execute "#{path_certs}ln -s /home/ubuntu/apps/#{@folder}/shared/config/certs/app_cert.pem"
  #     execute "#{path_certs}ln -s /home/ubuntu/apps/#{@folder}/shared/config/certs/app_key.pem"
  #   end
  # end
  #
  # task :staging_robot do
  #   on roles(:web) do
  #     execute "#{path_prefix_public}rm robots.txt"
  #     execute "#{path_prefix_public}ln -s /home/ubuntu/apps/#{@folder}/shared/public/robots.txt"
  #   end
  # end
  #
  # task :upload_yml do
  #   on roles(:web) do
  #     run_locally do
  #       execute("#{local_path_config}scp application.yml #{user}@#{server}:#{path_prefix_config_no_cd}/application.yml")
  #     end
  #   end
  # end
  #
  # task :server_restart do
  #   on roles(:web) do
  #     # execute "service nginx restart"
  #     execute! :sudo, :service, :nginx, :restart
  #   end
  # end
  #
  # after :deploy, "deploy:bundle"
  # after :deploy, "deploy:migrate"
  # after :deploy, "deploy:seed"
  # after :deploy, "deploy:symlink"
  # after :deploy, "deploy:precompile"
  # after :deploy, "deploy:staging_robot" if ENV["DEPLOY_PATH"] == "staging"
  # after :deploy, "deploy:upload_yml" if ENV["DEPLOY_PATH"] == "staging"
  # after :deploy, "deploy:server_restart"
end
