# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "curl_wrapper/version"

Gem::Specification.new do |s|
  s.name        = "curl_wrapper"
  s.version     = CurlWrapper::VERSION
  s.authors     = ["Ægir Örn Símonarson"]
  s.email       = ["agirorn@gmail.com"]
  s.homepage    = "https://github.com/agirorn/curl_wrapper"
  s.summary     = %q{DSL wraper for the curl command.}
  s.description = %q{Makes it easy to take you curl hacking from bash to ruby}
  
  s.rubyforge_project = "curl_wrapper"
  
  s.files        = Dir['CHANGELOG.md', 'MIT-LICENSE', 'README.rdoc', 'lib/**/*']
  
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  
  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
end
