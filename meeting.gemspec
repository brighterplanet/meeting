# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "meeting/version"

Gem::Specification.new do |s|
  s.name = %q{meeting}
  s.version = BrighterPlanet::Meeting::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", "Derek Kastner"]
  s.date = %q{2011-02-25}
  s.summary = %q{A carbon model}
  s.description = %q{A software model in Ruby for the greenhouse gas emissions of a meeting}
  s.email = %q{andy@rossmeissl.net}
  s.homepage = %q{https://github.com/brighterplanet/meeting}

  s.extra_rdoc_files = [
    "LICENSE",
     "LICENSE-PREAMBLE",
     "README.rdoc"
  ]

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency 'earth',     '~>0.12.1'
  s.add_dependency 'emitter', '~> 1.0.0'
  s.add_development_dependency 'sniff', '~> 1.0.0'
  s.add_development_dependency 'sqlite3'
end
