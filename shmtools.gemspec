# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shmtools/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Devin Ben-Hur"]
  gem.email         = ["dbenhur@whitepages.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.add_dependency 'ffi'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "shmtools"
  gem.require_paths = ["lib"]
  gem.version       = SHMTools::VERSION
end
