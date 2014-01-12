require 'bundler'
Bundler.require

require 'fileutils'

$LOAD_PATH << 'vendor/opal/lib'
require 'opal/builder'

desc 'Create directory if needed'
task :'build:setup' do
  Dir.mkdir 'JavaScriptCoreOpalAdditions/Opal.bundle' unless File.directory? 'JavaScriptCoreOpalAdditions/Opal.bundle'
  Dir.mkdir 'javascripts' unless File.directory? 'javascripts'
  Dir.mkdir 'javascripts/ruby' unless File.directory? 'javascripts/ruby'
end

desc 'Build opal.js and opal-parser.js'
task :'build:opal' => :'build:setup' do

  Opal::Processor.arity_check_enabled = false
  Opal::Processor.const_missing_enabled = false

  env = Opal::Environment.new

  Dir.mkdir 'javascripts' unless File.directory? 'javascripts'
  libs = Dir['vendor/opal/{opal,stdlib}/opal*.rb'].map { |lib| File.basename(lib, '.rb') }
  width = libs.map(&:size).max

  libs.each do |lib|
    print "* building #{lib}...".ljust(width+'* building ... '.size)
    $stdout.flush

    src = env[lib].to_s
    min = Uglifier.compile src, comments: "none"

    File.open("javascripts/#{lib}.js", 'w+')    { |f| f << min } if min
    print "done. ("
    print "#{('%.2f' % (src.size/1000.0)).rjust(6)}KB"
    print  ", minified: #{('%.2f' % (min.size/1000.0)).rjust(6)}KB" if min
    puts ")."
  end
end

desc 'Build opal Objective-c additions into javascripts/opal-objc.js'
task :'build:objc' => :'build:setup'  do

  Opal::Processor.arity_check_enabled = false
  Opal::Processor.const_missing_enabled = false

  env = Opal::Environment.new
  env.append_path "ruby"

  libs = Dir['ruby/*.rb'].map { |lib| File.basename(lib, '.rb') }
  width = libs.map(&:size).max

  libs.each do |lib|
    print "* building #{lib}...".ljust(width+'* building ... '.size)
    $stdout.flush

    src = env[lib].to_s
    min = Uglifier.compile src, comments: "none"

    File.open("javascripts/ruby/#{lib}.js", 'w+')    { |f| f << min } if min

    print "done. ("
    print "#{('%.2f' % (src.size/1000.0)).rjust(6)}KB"
    print  ", minified: #{('%.2f' % (min.size/1000.0)).rjust(6)}KB" if min
    puts ")."
  end

  print "* building opal-objc.js "
  src = Dir['javascripts/ruby/*.js'].collect {|file| open(file).read }.join("\n")
  File.open("javascripts/opal-objc.js", 'w+')    { |f| f << src } if src
  print "done. ("
  print "#{('%.2f' % (src.size/1000.0)).rjust(6)}KB"
  puts ")."
end

desc 'Copy stdlib resources into Opal.bundle'
task :'stdlib' => [:'build:setup'] do
  print "* building Opal.bundle "
  Dir["JavaScriptCoreOpalAdditions/Opal.bundle/*"].each do |file|
    FileUtils.rm file
  end
  Dir['javascripts/opal-all.js', 'vendor/opal/stdlib/*.rb'].each do |file|
    FileUtils.cp file, "JavaScriptCoreOpalAdditions/Opal.bundle"
  end
end

desc 'Build javascript/opal-all.js'
task :'dist' => [:'build:setup', :'build:opal', :'build:objc', :'stdlib'] do
  print "* building opal-all.js "
  src = Dir['javascripts/{opal.js,opal-parser.js,opal-objc.js}'].collect {|file| open(file).read }.join("\n")
  File.open("javascripts/opal-all.js", 'w+')    { |f| f << src } if src
  print "done. ("
  print "#{('%.2f' % (src.size/1000.0)).rjust(6)}KB"
  puts ")."
end

task :default => :'dist'