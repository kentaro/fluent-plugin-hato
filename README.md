# Fluent::Plugin::Hato [![BuildStatus](https://secure.travis-ci.org/kentaro/fluent-plugin-hato.png)](http://travis-ci.org/kentaro/fluent-plugin-hato)

## Component

### HatoOutput

fluent-plugin-hato is a plugin for Fluentd to send messages via [Hato](http://github.com/kentaro/hato).

## Usage

### Synopsis

```
<match notification.**>
  type           hato

  api_key        YOUR_API_KEY
  scheme         http
  host           hato.example.com
  port           9699
  message_keys   foo, bar, baz
  message_format [notification] %s %s %s
</match>
```

### Params

#### `api_key` (required)

API key for your Hato installation.

#### `scheme` (optional: default = 'http')

Schema for your Hato installation.

#### `host` (required)

Host for your Hato installation.

#### `port` (optional: default = 9699)

Port for your Hato installation.

#### `message_keys` (optional: default = '')

Keys represented by comma-separated value for message.

#### `message_format` (optional: default = '')

Message format.

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-hato'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-hato

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

