#!/usr/bin/env ruby

require 'fileutils'

preview_dir = File.join(ENV['HOME'], 'Dropbox', 'sprk2012', 'web-preview')
branch = `git symbolic-ref HEAD`.chomp.split('/').last

source_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
destination_dir = File.join(preview_dir, branch)

puts "Copying jekyll sources into Dropbox..."
puts
puts "%s (%s) -> %s" % [source_dir, branch, destination_dir]
FileUtils.mkdir_p(destination_dir)
Dir.chdir source_dir do
  ret = system "git archive --format tar HEAD | tar -C #{destination_dir} -xf -"
  raise "git failed" unless ret
end
