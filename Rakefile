require 'rubygems'

require 'bundler'
Bundler.setup

require 'bueller'
Bueller::Tasks.new

require 'sniff'
require 'sniff/rake_tasks'
Sniff::RakeTasks.define_tasks do |t|
  t.earth_domains = [:locality, :fuel]
end
