#require 'mina/rails'
#require 'mina/git'
## require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
## require 'mina/rvm'    # for rvm support. (https://rvm.io)
#
## Basic settings:
##   domain       - The hostname to SSH to.
##   deploy_to    - Path to deploy into.
##   repository   - Git repo to clone from. (needed by mina/git)
##   branch       - Branch name to deploy. (needed by mina/git)
#
#set :application_name, ''
#set :domain, ''
#set :branch, ''
#
#set :user, ''
#
#set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application_name)}"
#set :repository, ''
#set :term_mode, nil
#set :forward_agent, true
#set :keep_releases, 1
#
## Optional settings:
##   set :user, 'foobar'          # Username in the server to SSH to.
##   set :port, '30000'           # SSH port number.
##   set :forward_agent, true     # SSH forward_agent.
#
#deploy_to = fetch(:deploy_to)
#shared_path = 'shared'
#
#
#shared_files_list = [
#    'config/database.yml',
#    'config/redis.yml',
#    'config/master.key',
#    'config/credentials.yml.enc'
#]
#set :shared_files, fetch(:shared_files, []).push(*shared_files_list)
#
## Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
## Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
## run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
## set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
## set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')
#
## This task is the environment that is loaded for all remote run commands, such as
## `mina deploy` or `mina rake`.
#task :remote_environment do
#  comment 'Initialize asdf'
#  command %{source ~/.asdf/asdf.sh}
#  command %{export PATH=$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH}
#end
#
## Put any custom commands you need to run at setup
## All paths in `shared_dirs` and `shared_paths` will be created on their own.
#task :setup do
#  command %{mkdir -p "#{deploy_to}/#{shared_path}/tmp/log"}
#  command %{chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/log"}
#
#  command %{mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets"}
#  command %{chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets"}
#
#  command %{mkdir -p "#{deploy_to}/#{shared_path}/config/initializers"}
#  command %{chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config/initializers"}
#
#  command %{mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids"}
#  command %{chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids"}
#end
#
#task :puma_stop => :remote_environment do
#  comment 'Stop Puma'
#  command %{sudo systemctl stop "app-#{ fetch(:application_name) }@5000.service"}
#end
#
#task :puma_start => :remote_environment do
#  comment 'Start Puma'
#  command %{sudo systemctl start "app-#{ fetch(:application_name) }@5000.service"}
#end
#
#desc "Deploys the current version to the server."
#task :deploy => :remote_environment do
#  # uncomment this line to make sure you pushed your local branch to the remote origin
#  # invoke :'git:ensure_pushed'
#  deploy do
#    # Put things that will set up an empty directory into a fully set-up
#    # instance of your project.
#    invoke :'git:clone'
#    invoke :'deploy:link_shared_paths'
#    invoke :'bundle:install'
#    invoke :'rails:db_migrate'
#    invoke :'deploy:cleanup'
#
#    on :launch do
#      # invoke :'puma_stop'
#      # invoke :'puma_start'
#
#      in_path(fetch(:current_path)) do
#        comment 'Done.'
#      end
#    end
#  end
#
#  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
#  # run(:local){ say 'done' }
#end
#
## For help in making your deploy script, see the Mina documentation:
##
##  - https://github.com/mina-deploy/mina/tree/master/docs
#
#puts
#puts "\e[32mProject configuration\e[0m"
#puts "\e[33m----------------------------------\e[0m"
#puts "\e[36mDomain:\e[0m \e[35m#{ fetch(:domain) }\e[0m"
#puts "\e[36mApp:\e[0m \e[35m#{ fetch(:application_name) }\e[0m"
#puts "\e[36mBranch:\e[0m \e[35m#{ fetch(:branch) }\e[0m"
#puts "\e[33m----------------------------------\e[0m"
