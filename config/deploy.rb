require 'yaml'

config_map = YAML.load_file(File.expand_path("../deploy.yml", __FILE__))

# config valid only for current version of Capistrano
# lock '3.4.0'

set :application, 'express'
set :repo_url, 'git@github.com:adlerhsieh/express.git'
set :deploy_to, "/home/#{config_map["production"]["user"]}/apps/express"
set :rbenv_ruby, File.read(File.expand_path("../../.ruby-version", __FILE__)).strip

@folder = "express"

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
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml', 'config/application.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# role :web, %w{motionex@107.170.207.41}
role :web, config_map["production"]["role"]["web"]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

  task :server_restart do
    on roles(:web) do
      # execute "service nginx restart"
      execute! :sudo, :service, :unicorn_express, :kill
      sleep(2)
      execute! :sudo, :service, :unicorn_express, :init
    end
  end

  after :deploy, "deploy:server_restart"
end
