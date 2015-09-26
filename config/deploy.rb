# config/deploy.rb
require "bundler/capistrano"
require 'capistrano/ext/multistage'
require 'rest-client'

set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }

require 'whenever/capistrano'

set :stages, %w(staging production)
# set :default_stage, "beta"

set :application,     "ola-hackathon"
set :scm,             :git
set :repository,      "git@github.com:mksunda/ola-hackathon.git"
set :branch,          "origin/master"

# set :use_sudo,        false
# set :migrate_target,  :current
# set :ssh_options,     { :forward_agent => true }
# set :rails_env,       "production"
# set :user,            "alpha"
# set :group,           "alpha"
# set :use_sudo,        false
#

set :deploy_to,       "/home/ops/ola-hackathon" # TODO
set :normalize_asset_timestamps, false

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }
default_run_options[:shell] = 'bash'
default_run_options[:pty] = true

after 'deploy:update_code', 'deploy:migrate'

namespace :deploy do

  desc "Setup your git-based deployment app"
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
  end

  task :cold do
    update
    migrate
  end

  desc "Deploy latest code"
  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    update
    migrate
  end

  #---- my own precompile task -------

  desc "Forced pre-compilation of assets"
  task :precompile, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path} && #{rake} RAILS_ENV=production #{asset_env} assets:precompile"
  end

  after "deploy:create_symlink", "deploy:update_crontab"
  desc "Update the crontab file"
  task :update_crontab, :roles => :app do
    run "cd #{current_path} && whenever --update-crontab #{application}"
  end

  # Start DB -----------------------------------------------------
  namespace :db do

    desc "reload the database with seed data"
    task :seed do
      run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
    end

    desc "reset the database"
    task :reset do
      run "cd #{current_path}; bundle exec rake db:reset RAILS_ENV=#{rails_env}"
    end
  end
  # End DB -----------------------------------------------------

  # desc "Zero-downtime restart of Passenger"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # Start Code update --------------------------------------------------
  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
      run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
      finalize_update
  end


  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    run <<-CMD
      ln -sf /home/ops/config/database.yml #{latest_release}/config/database.yml;
      ln -sf /home/ops/config/rabbit.yml #{latest_release}/config/rabbit.yml;
    CMD
    #rm -rf #{latest_release}/log #{latest_release}/tmp/pids &&
    # rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
    # mkdir -p #{latest_release}/public &&
    # mkdir -p #{latest_release}/tmp &&
    # ln -s #{shared_path}/log #{latest_release}/log &&
    # ln -s #{shared_path}/system #{latest_release}/public/system &&
    # ln -s #{shared_path}/pids #{latest_release}/tmp/pids &&

    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
      run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
    end
  end
  # End Code update -----------------------------------------------------

end

def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end
