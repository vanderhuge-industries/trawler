require 'mongoid'

require 'trawler/stores/visible'

# Ensure Kaminari is initialized (if it is present) before our models are loaded
begin; require 'kaminari'; rescue LoadError; end
if defined? ::Kaminari
  puts "Kicking off Kaminari init"
  ::Kaminari::Hooks.init
end

Dir["#{File.dirname(__FILE__)}/trawler/**/*.rb"].each { |rb| require rb }
