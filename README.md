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

Use `:rvm_type` to indicate whether to use a single user installation or rvm
or a multi-user (or system) installation of rvm. If you specify `:user`,
capistrano expects to find your rvm installation in `~/.rvm`. If you specify
`:system`, capistrano expects to find your rvm installation in
`/usr/local/rvm`. If you have rvm installed elsewhere, use `rvm_custom_path`
to tell capistrano where it is:

    set :rvm_type, :user
    set :rvm_custom_path, '~/.myveryownrvm'

You can omit the ruby patch level from `:rvm_ruby_version` if you want, and
capistrano will choose the most recent patch level for that version of ruby:

    set :rvm_ruby_version '2.0.0'

If you are using an rvm gemset, just specify it after your ruby_version:

    set :rvm_ruby_version, '2.0.0-p247@mygemset'

or

    set :rvm_ruby_version, '2.0.0@mygemset'

Capistrano can't (yet) use rvm to install rubies or create gemsets, so on the
servers you are deploying to, you will have to manually use rvm to install
the proper ruby and create the gemset.


## How it works

This gem adds a new task `rvm:create_wrappers` before `deploy:starting`. This
task uses the `rvm wrapper` command to create a wrapper scripts for this
application that use the desired ruby and gemset. These wrapper scripts are
then used by capistrano when it wants to run `rake`, `gem`, `bundle`, or
`ruby`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
