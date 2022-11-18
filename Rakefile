# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "rake/extensiontask"

task build: :compile

Rake::ExtensionTask.new("rubocop_sorted_methods_by_call") do |ext|
  ext.lib_dir = "lib/rubocop_sorted_methods_by_call"
end

task default: %i[clobber compile spec rubocop]
