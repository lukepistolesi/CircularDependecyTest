#!/usr/bin/env ruby
require './circular_dep_app/application.rb'

CircularDepApp::Application.run ARGV.dup
