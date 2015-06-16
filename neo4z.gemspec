# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'neo4z/version'

Gem::Specification.new do |spec|
  spec.name          = "neo4z"
  spec.version       = Neo4z::VERSION
  spec.authors       = ["Hiroyuki Sato"]
  spec.email         = ["hiroyuki_sato@spiber.jp"]
  spec.summary       = %q{A graph database for Ruby}
  spec.description   = %q{A Neo4j OGM (Object-Graph-Mapper) for use in Ruby on Rails and Rack frameworks heavily inspired by ActiveRecord.}
  spec.homepage      = "https://github.com/hiroponz/neo4z"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "activemodel", "~>3.2.0"
  spec.add_runtime_dependency "activesupport", "~>3.2.0"
  spec.add_runtime_dependency "neography", "~>1.6.0"
  spec.add_runtime_dependency "will_paginate", "~>3.0.0"
end
