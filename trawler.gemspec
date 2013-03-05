# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trawler/version'

Gem::Specification.new do |gem|
  gem.name          = "trawler"
  gem.version       = Trawler::VERSION
  gem.authors       = ["Ray Grasso"]
  gem.email         = ["ray.grasso@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'lastfm', [ '>= 0' ]
  gem.add_dependency 'mongoid', [ '>= 3' ]
  gem.add_dependency 'database_cleaner', [ '>= 0.9' ]

  gem.add_development_dependency 'rspec', [ '>= 0' ]
  gem.add_development_dependency 'pry', [ '>= 0' ]
  gem.add_development_dependency 'mongoid-rspec', [ '>= 0' ]
end
