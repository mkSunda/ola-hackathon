# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ola-hackathon'
set :repo_url, 'git@github.com:mkSunda/ola-hackathon.git'

set :branch, 'master'
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :ssh_options, {
  forward_agent: true,
  port: 22
}

set :rvm_ruby_version, '2.1.3@ola'      # Defaults to: 'default'

set :format, :pretty
set :log_level, :debug
set :pty, true

set :deploy_to, '/home/ops/ola-hackathon'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
before "deploy:assets:precompile", "deploy:symlink:linked_files"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

task :config_symlink do
  execute "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end
