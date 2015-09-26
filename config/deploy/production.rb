# config/deploy/ops.rb

server '128.199.190.7', :app, :web, :primary => true

set :rails_env,   "production"
set :branch,      "origin/master"
set :user,        "ops"
set :group,       "ops"
set :use_sudo,    false

