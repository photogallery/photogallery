#puts "Discovery"
$:.push(File.join(File.dirname(__FILE__), %w[.. .. .. rspec]))  
#$:.push("/usr/lib/ruby/gems/1.8/gems/rspec-1.1.11")
##require "/usr/lib/ruby/gems/1.8/gems/rspec-1.1.11/lib/autotest/rspec.rb"
#puts
puts $:.inspect
#
#Autotest.add_discovery do  
#    "rspec-1.1.11"
#end
#puts "Discovery"

Autotest.add_discovery do
  "rspec" 
end
