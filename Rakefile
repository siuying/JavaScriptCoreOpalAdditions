require 'bundler'
Bundler.require


$LOAD_PATH << 'vendor/opal/lib'
require 'opal'

desc 'Build opal.js and opal-parser.js to build/'
task :dist do
  Opal::Processor.arity_check_enabled = false
  Opal::Processor.const_missing_enabled = false

  env = Opal::Environment.new

  Dir.mkdir 'javascripts' unless File.directory? 'javascripts'
  libs = Dir['vendor/opal/{opal,stdlib}/*.rb'].map { |lib| File.basename(lib, '.rb') }
  width = libs.map(&:size).max

  libs.each do |lib|
    print "* building #{lib}...".ljust(width+'* building ... '.size)
    $stdout.flush

    src = env[lib].to_s

    File.open("javascripts/#{lib}.js", 'w+') { |f| f << src }
    print "done. ("
    print "#{('%.2f' % (src.size/1000.0)).rjust(6)}KB"
    puts ")."
  end
end

task :default => :dist