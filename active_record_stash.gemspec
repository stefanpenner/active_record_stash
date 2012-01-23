# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_record_stash/version"

Gem::Specification.new do |s|
  s.name        = "active_record_stash"
  s.version     = ActiveRecordStash::VERSION
  s.authors     = ["Stefan Penner"]
  s.email       = ["stefan.penner@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Validations for serialized ActiveRecrd fields}
  s.description = %q{ActiveRecordStash provides a helpful syntax, which faciliates active_model compliant attributes, which are stored within a single serialized attribute. Poor mans NoSQL with AR}

  s.rubyforge_project = "active_record_stash"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
