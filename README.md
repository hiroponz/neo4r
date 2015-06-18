# Neo4r

Neo4r is an Active Model compliant Ruby wrapper for [the Neo4j graph database](http://neo4j.com/). It uses [the Neography](https://github.com/maxdemarzi/neography) gems.


## Requirement

- ruby ~> 2.1
- neography ~> 1.6

## Neo4j version support

- 2.0.x
- 2.1.x

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'neo4r'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install neo4r

## Usage

### Configuration

Neo4r uses Neography to handle Neo4j REST API. So the configuration is same with Neography.
Please see [the Neography document](https://github.com/maxdemarzi/neography/tree/v1.6.0#configuration-and-initialization).

### Modeling

A sample Node model.

```ruby
class User < Neo4r::Node
end
```

Create a new node.

```ruby
user = User.new
user.name = "Hiroyuki Sato"
user.mail = "hiroyuki@example.com"
user.age = 35
user.save # => true
```

Search nodes.
**The syntax of an exact match is only implemented.**

```ruby
users = User.where(name: "Hiroyuki Sato")
puts users.first.name # => "Hiroyuki Sato"
```

Update nodes.

```ruby
user = User.where(name: "Hiroyuki Sato").first
user.age = 36
user.save # => true
```

Delete nodes.

```ruby
user = User.where(name: "Hiroyuki Sato").first
user.delete => true
```

Add connection.

```ruby
ozawa = User.new
ozawa.name = "Kunio Ozawa"
ozawa.save

sato = User.new
sato.name = "Hiroyuki Sato"
sato.save

nakamura = User.new
nakamura.name = "Hiroyuki Nakamura"
nakamura.save

sugahara = User.new
sugahara.name = "Junichi Sugahara"
sugahara.save

nakamura.incoming(:boss) << ozawa
nakamura.incoming(:boss) << sato
sugahara.incoming(:boss) << nakamura
```

Traverse connection.

```ruby
sugahara.incoming(:boss).each { |user| puts user.name }
# output
# => "Hiroyuki Nakamura"
sugahara.incoming(:boss).depth(:all).each { |user| puts user.name }
# output
# => "Hiroyuki Nakamura"
# => "Hiroyuki Sato"
# => "Kunio Ozawa"
```

Delete connection.

```ruby
nakamura.rels(:boss).to_other(sato).destroy
```

## Contributing

1. Fork it ( https://github.com/hiroponz/neo4r/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
