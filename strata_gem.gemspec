# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "strata_gem/version"

Gem::Specification.new do |s|
  s.name        = "strata_gem"
  s.version     = StrataGem::VERSION
  s.authors     = ["Alexander Sweeney"]
  s.email       = ["asweeney@stratajet.com"]
  s.homepage    = ""
  s.summary     = %q{Interfaces with the Stratjet API}
  s.description = %q{A simple hello world gem}
  
  s.rubyforge_project = "strata_gem"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_runtime_dependency "oauth2"
  s.add_runtime_dependency "json"
end
