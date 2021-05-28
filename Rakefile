# Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

# Rubocop
desc 'Run Rubocop lint checks'
task :rubocop do
  RuboCop::RakeTask.new
end

namespace :test do
  # run inspec check to verify that the profile is properly configured
  task :check do
    require 'inspec'
    puts "Checking profile with InSpec Version: #{Inspec::VERSION}"
    profile = Inspec::Profile.for_target('.', backend: Inspec::Backend.create(Inspec::Config.mock))
    pp profile.check
  end
end

# lint the project
desc 'Run robocop linter'
task lint: [:rubocop]

# run tests
task default: [:lint, 'test:check']
