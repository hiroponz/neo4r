# Neo4z

Neo4z is an Active Model compliant Ruby wrapper for [the Neo4j graph database](http://neo4j.com/). It uses [the Neography](https://github.com/maxdemarzi/neography) gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'neo4z'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install neo4z

## Usage

```ruby
# Create class Inheriting Neo4z::Node
klass = Object.const_set("ClassName", Class.new(Neo4z::Node))

klass.count # => Get node count
klass.all # => Get all nodes
```

## Contributing

1. Fork it ( https://github.com/hiroponz/neo4z/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
