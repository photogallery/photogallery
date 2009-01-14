### Copy javascript, css, and image files to /public/
require 'ftools'

DEST = File.join(File.dirname(__FILE__), '..', '..', '..', 'public')
SOURCE = File.join(File.dirname(__FILE__), 'public')

def copy_all(dir)
  dest = File.join(DEST, dir, 'photo_gallery')
  source = File.join(SOURCE, dir)

  if File.exists?(dest)
    unless File.directory?(dest)
      raise "#{dest} already exists but is not a directory"
    end
  else
    raise("Unable to create #{dest}") unless File.makedirs(dest)
  end

  Dir[File.join(source, '*')].each do |file|
    File.copy(file, dest, true)
  end
end

def requirement_failed(failures)
  puts
  puts "!!"
  puts "!!  ERROR INSTALLING PLUGIN! The following required plugins don't seem to be installed: #{failures.join(", ")}"
  puts "!!"
  raise
end

def find_plugin(name)
  dir = File.join(File.dirname(__FILE__), "..", name)
  File.directory?(dir)
end

def check_requirements
  failures = []
  puts "Checking Requirements..."
  print "ActsAsTree: "
  if find_plugin("acts_as_tree")
    puts "found"
  else
    puts "MISSING"
    failures << "ActsAsTree"
  end
  print "Paperclip: "
  if find_plugin("paperclip")
    puts "found"
  else
    puts "MISSING"
    failures << "Paperclip" 
  end
  requirement_failed(failures) unless failures.empty?
end

puts "Copying js, images, and css"
copy_all('javascripts')
copy_all('images')
copy_all('stylesheets')

puts
puts "Copying example config file to config/"
File.copy(File.join(File.dirname(__FILE__), "config", "photo_gallery.rb"), File.join(File.dirname(__FILE__), "..", "..", "..", "config"), true)

puts
check_requirements

puts
puts "PhotoGallery Successfully installed. You'll need to create and run a migration. You can find configuration options in config/photo_gallery.rb"
