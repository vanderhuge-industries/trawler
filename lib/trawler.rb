require 'mongoid'

require 'trawler/stores/visible'

Dir["#{File.dirname(__FILE__)}/trawler/**/*.rb"].each { |rb| require rb }
