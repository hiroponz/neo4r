# Aneo

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aneo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aneo

## Usage

```
# Create class Inheriting Aneo::Node
klass = Object.const_set("ClassName", Class.new(Aneo::Node))

klass.count # => Get node count
klass.all # => Get all nodes
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aneo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
