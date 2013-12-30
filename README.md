# Capistrano::RVM

RVM  automated support for Capistrano v3.
Includes task to install RVM and Ruby.

## Notes

**If you use this integration with capistrano-rails, please ensure that you have `capistrano-bundler >= 1.1.0`.**

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'capistrano', '~> 3.0'
gem 'capistrano-rvm'
```

And then execute:

```bash
$ bundle install
```

## Usage

Require in `Capfile` to use the default task:

```ruby
require 'capistrano/rvm'
```

And you should be good to go!

It will automatically:

- detect rvm installation path, preferring user installation
- detect ruby from project directory
- create the gemset if not existing already

Automatically done by RVM:

- [rubygems-bundler](https://github.com/mpapis/rubygems-bundler#readme)
  gem which is installed by default with RVM causes automatic call of
  `Bundler.setup` which is equivalent of `bundle exec`.

## Configuration

Well if you really need to there are available ways:

- `set :rvm_ruby_version, "2.0.0"` - to avoid autodetection and use specific version
- `fetch(:default_env).merge!( rvm_path: "/opt/rvm" )` - to force specific path to rvm installation

## Install RVM 1.x

This task will install stable version of rvm in `$HOME/.rvm`:
```bash
cap rvm:install:rvm
```

Or add an before hook:
```ruby
before 'deploy', 'rvm:install:rvm'  # install/update RVM
```

## Install Ruby

This task will install ruby from the project (other the specified one):
```bash
cap rvm:install:ruby
```

Or add an before hook:
```ruby
before 'deploy', 'rvm:install:ruby'  # install/update Ruby
```

This task requires [`NOPASSWD` for the user in `/etc/sudoers`](http://serverfault.com/a/160587),
or at least all ruby requirements installed already.

Please note that `NOPASSWD` can bring security vulnerabilities to your system and
it's not recommended to involve this option unless you really understand implications of it.

## How it works

This gem adds a new task `rvm:hook` before `deploy:starting`.
It uses the [script/rvm-auto.sh](script/rvm-auto.sh) for capistrano when it wants to run
`rake`, `gem`, `bundle`, or `ruby`.

## Check your configuration

If you want to check your configuration you can use the `rvm:check` task to
get information about the RVM version and ruby which would be used for
deployment.

    $ cap production rvm:check

## Custom tasks which rely on RVM/Ruby

When building custom tasks which need the current ruby version and gemset, all you
have to do is run the `rvm:hook` task before your own task. This will handle
the execution of the ruby-related commands.
This is only necessary if your task is *not* *after* the `deploy:starting` task.

    before :my_custom_task, 'rvm:hook'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. When changing `script/` test your changes (`tf --text test/*.sh`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
