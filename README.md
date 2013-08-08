# Capistrano::RVM

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano', version: '~> 3.0.0'
    gem 'capistrano-rvm', github: "capistrano/rvm"

And then execute:

    $ bundle --binstubs
    $ cap install

## Usage

    # Capfile

    require 'capistrano/rvm'

    set :rvm_type, :user # or :system, depends on your rvm setup
    set :rvm_ruby_version, '2.0.0-p247'

If your rvm is located in some custom path, you can use `rvm_custom_path` to set it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
