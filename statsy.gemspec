# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'statsy'

Gem::Specification.new do |gem|
  gem.name          = "statsy"
  gem.version       = Statsy::VERSION
  gem.authors       = ["Alan Harper"]
  gem.email         = ["alan@sct.com.au"]
  gem.description   = %q{Client gem for Statsy}
  gem.summary       = %q{Gem to send data to the Statsy time series data collection service (statsyapp.com)}
  gem.homepage      = "http://www.statsyapp.com/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "fakeweb"
  gem.add_development_dependency "rake"
end
