lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rvm1/capistrano3/version'

Gem::Specification.new do |spec|
  spec.name        = 'rvm1-capistrano3'
  spec.version     = ::RVM1::Capistrano3::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Michal Papis']
  spec.email       = ['mpapis@gmail.com']
  spec.homepage    = 'https://github.com/rvm/rvm1-capistrano3'
  spec.summary     =
  spec.description = 'RVM 1.x / Capistrano 3.x Integration Gem'
  spec.license     = 'Apache 2'

  spec.add_dependency 'capistrano', '~>3.0'

  spec.files        = Dir.glob('lib/**/*.rb')
  # spec.test_files   = Dir.glob('spec/**/*.rb')
end
