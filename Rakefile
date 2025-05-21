require "bundler/setup"
require "rake/testtask"
require "bundler/gem_tasks"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"].exclude("test/dummy/rails_app/test/**/*_test.rb")
end

Rake::TestTask.new(:dummy_rails_test) do |t|
  t.libs << "test/dummy/rails_app/test"
  t.test_files = FileList["test/dummy/rails_app/test/**/*_test.rb"]
  t.verbose = true
end

# namespace :test do
#   desc "Setup dummy apps"
#   task :setup do
#     sh "cd test/dummy/rails_app && bundle install"
#     # You can add any other setup steps needed for Sinatra or Rails here
#   end
# end

desc "Run tests"
task default: :test

desc "Run dummy app tests"
task :dummy_rails_test do
  Rake::Task["dummy_rails_test"].invoke
end
