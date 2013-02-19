# Configurator [![Build Status](https://travis-ci.org/jilion/configurator.png?branch=master)](https://travis-ci.org/jilion/configurator) [![Code Climate](https://codeclimate.com/github/jilion/configurator.png)](https://codeclimate.com/github/jilion/configurator)

Simple yaml config loader for Ruby Class (using ActiveSupport::Concern)

## Installation

Add this line to your application's Gemfile:

    gem 'configurator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install configurator

## Usage

In the class/module where you want some config variable:

``` ruby
require 'configurator'

class Foo
  include Configurator

  config_file 'foo.yml'
  config_accessor :bar
end
```

with this `config/foo.yml` yaml file:

``` yaml
development:
  bar: foo

staging:
  bar: foo

production:
  bar: foo
```

### Options

#### Without Rails.env

You can also skip Rails.env in your yaml file by passing `rails_env: false` to `config_file` method:

``` ruby
require 'configurator'

class Foo
  include Configurator

  config_file 'foo.yml', rails_env: false
  config_accessor :bar
end
```

with this `config/foo.yml` yaml file:

``` yaml
bar: foo
```

#### With ENV variable

You can use env_var in your yaml to automatically fallback to ENV variable (useful on Heroku):

``` ruby
require 'configurator'

class Foo
  include Configurator

  config_file 'foo.yml'
  config_accessor :bar
end
```

with this `config/foo.yml` yaml file:

``` yaml
development:
  bar: foo

staging:
  bar: env_bar

production:
  bar: env_bar
```

This will automatically load `ENV['FOO_BAR']` variable. Handy!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
