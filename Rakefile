# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

require "yard"
YARD::Rake::YardocTask.new

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

namespace :test do
  desc "Run integration tests using localstack"
  Rake::TestTask.new(:integration) do |t|
    t.libs << "integration"
    t.test_files = FileList["integration/**/*_test.rb"]
  end
end

task default: :test
