# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "charset_filter/version"

Gem::Specification.new do |s|
  s.name        = "charset_filter"
  s.version     = CharsetFilter::VERSION
  s.authors     = ["Ronan Limon Duparcmeur"]
  s.homepage    = "https://github.com/Hospimedia/CharsetFilter"
  s.description = "Middleware Rack pour corriger les paramètres GET mal encodés"
  s.summary     = "Middleware Rack pour corriger les paramètres GET mal encodés"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  
  s.add_development_dependency "rspec",     "~> 2.6.0"
  s.add_runtime_dependency     "rack"
  s.add_runtime_dependency     "rchardet19"
end
