#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

ChordateUi::Application.load_tasks

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'
load 'jasmine/tasks/jasmine_rails3.rake'

task :default => ['i18n:js:export', :spec, 'jasmine:ci']
