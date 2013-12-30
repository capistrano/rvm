# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'capistrano/rvm/version'

Gem::Specification.new do |gem|
  gem.name          = "capistrano-rvm"
  gem.version       = ::Capistrano::Rvm::VERSION
  gem.authors       = ["Kir Shatrov",    'Michal Papis']
  gem.email         = ["shatrov@me.com", 'mpapis@gmail.com']
  gem.licenses      = ["Apache 2", "MIT"]
  gem.description   = %q{RVM integration for Capistrano}
  gem.summary       = %q{RVM integration for Capistrano}
  gem.homepage      = "https://github.com/capistrano/rvm"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency 'capistrano', '~> 3.0'
  gem.add_dependency 'sshkit', '~> 1.2'

  gem.add_development_dependency 'tf', '~>0.4.3'
end
