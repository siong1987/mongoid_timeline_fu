# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongoid_timeline_fu/version"

Gem::Specification.new do |s|
  s.name        = "mongoid_timeline_fu"
  s.version     = MongoidTimelineFu::VERSION
  s.authors     = ["Teng Siong Ong"]
  s.email       = ["siong1987@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Easily build timelines, much like GitHub's news feed. But, on Mongoid tho.}
  s.description = %q{Easily build timelines, much like GitHub's news feed. But, on Mongoid tho.}

  s.rubyforge_project = "mongoid_timeline_fu"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "mocha"
  s.add_dependency("mongoid", "~> 3")
end
