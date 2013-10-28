# RVM 1.x Capistrano 3.x integration

An automated version of the integration requiring minial configuration.

## Installation

Add `rvm1-capistrano3` gem to `Gemfile` or just install the gem.

## Usage

In `Capfile` add

```ruby
require 'rvm1/capistrano3'
```

It will automatically:

- detect rvm installation path, preffering user installation
- detect ruby from project directory
- detect Gemfile and use `bundle exec`
- create the gemset if not existing already

## Install RVM 1.x

This task will install stable version of rvm in `$HOME/.rvm`:
```bash
cap rvm1:install:rvm
```

Or add an before hook:
```ruby
before 'deploy', 'rvm1:install:rvm'  # install/update RVM
```

## Install Ruby

This task will install ruby from the project (other the specified one):
```bash
cap rvm1:install:ruby
```

Or add an before hook:
```ruby
before 'deploy', 'rvm1:install:ruby'  # install/update Ruby
```

This task requires [`NOPASSWD` for the user in `/etc/sudoers`](http://serverfault.com/a/160587),
or at least all ruby requirements installed already.

## Configuration

Weel if you really need to this are available ways:

- `set :rvm1_ruby_version, "2.0.0"` - to avoid autodetection and use specific version
- `fetch(:default_env).merge!( rvm_path: "/opt/rvm" )` - to force specific path to rvm installation

## How it works

This gem adds a new task `rvm1:hook` before `deploy:starting`.
It uses the [script/rvm-auto.sh](script/rvm-auto.sh) for capistrano when it wants to run
`rake`, `gem`, `bundle`, or `ruby`.

## Check your configuration

If you want to check your configuration you can use the `rvm1:check` task to
get information about the RVM version and ruby which would be used for
deployment.

    $ cap production rvm1:check

## Custom tasks which rely on RVM/Ruby

When building custom tasks which need a the corrent ruby and gemset, all you
have to do is run the `rvm1:hook` task before your own task. This will handle
the execution of the ruby-related commands.
This is only necessary if your task is *not* *after* the `deploy:starting` task.

    before :my_custom_task, 'rvm1:hook'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Test your changes (`tf --text test/*.sh`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
