# Capistrano::RVM

RVM support for Capistrano 3.x

## Installation

Add this line to your application's Gemfile:

    # Gemfile
    gem 'capistrano', '~> 3.0'
    gem 'capistrano-rvm', '~> 0.0.3'

And then execute:

    $ bundle --binstubs
    $ cap install

## Usage

Require in Capfile to use the default task:

    # Capfile
    require 'capistrano/rvm'

And you should be good to go!

## Configuration

Set those in the stage file dependant on your server configuration:

    # stage file (staging.rb, production.rb or else)
    set :rvm_type, :user
    set :rvm_ruby_version, '2.0.0-p247'
    set :rvm_custom_path, '~/.myveryownrvm'

### RVM path selection: `:rvm_type`

Valid options are:
  * `:auto` (default): just tries to find the correct path.
                       `~/.rvm` wins over `/usr/local/rvm`
  * `:system`: defines the RVM path to `/usr/local/rvm`
  * `:user`: defines the RVM path to `~/.rvm`

### Ruby and gemset selection: `:rvm_ruby_version`

By default the Ruby and gemset is used which is returned by `rvm current` on
the target host.

You can omit the ruby patch level from `:rvm_ruby_version` if you want, and
capistrano will choose the most recent patch level for that version of ruby:

    set :rvm_ruby_version '2.0.0'

If you are using an rvm gemset, just specify it after your ruby_version:

    set :rvm_ruby_version, '2.0.0-p247@mygemset'

or

    set :rvm_ruby_version, '2.0.0@mygemset'


### Custom RVM path: `:rvm_custom_path`

If you have a custom RVM setup with a different path then expected, you have
to define a custom RVM path to tell capistrano where it is.


## Restrictions

Capistrano can't (yet) use rvm to install rubies or create gemsets, so on the
servers you are deploying to, you will have to manually use rvm to install the
proper ruby and create the gemset.


## How it works

This gem adds a new task `rvm:hook` before `deploy:starting`.
It sets the `rvm ... do ...` for capistrano when it wants to run
`rake`, `gem`, `bundle`, or `ruby`.


## Check your configuration

If you want to check your configuration you can use the `rvm:check` task to
get information about the RVM version and ruby which would be used for
deployment.

    $ cap production rvm:check


## Custom tasks which rely on RVM/Ruby

When building custom tasks which need a the corrent ruby and gemset, all you
have to do is run the `rvm:hook` task before your own task. This will handle
the execution of the ruby-related commands.
This is only necessary if your task is *not* *after* the `deploy:starting` task.

    before :my_custom_task, 'rvm:hook'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
