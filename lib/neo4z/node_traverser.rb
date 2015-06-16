module Neo4z
  # Node traverser class
  class NodeTraverser
    include Enumerable

    attr_accessor :order, :uniqueness, :depth, :prune, :filter, :relationships
    attr_reader :rest

    def initialize(from, types = nil, dir = "all")
      @rest = RestWrapper.new
      @from  = from
      @order = "depth first"
      @uniqueness = "none"
      @relationships = []
      types.each do |type|
        @relationships << { "type" => type.to_s, "direction" => dir.to_s }
      end unless types.nil?
    end

    def <<(other_node)
      create(other_node)
      self
    end

    def create(other_node)
      case @relationships.first["direction"]
      when "outgoing", "out"
        rel = Relationship.create(
          type: @relationships.first["type"], start: @from, end: other_node)
      when "incoming", "in"
        rel = Relationship.create(
          type: @relationships.first["type"], start: other_node, end: @from)
      else
        rel = []
        rel << Relationship.create(
          type: @relationships.first["type"], start: @from, end: other_node)
        rel << Relationship.create(
          type: @relationships.first["type"], start: other_node, end: @from)
      end
      rel
    end

    def both(type)
      @relationships << { "type" => type.to_s, "direction" => "all" }
      self
    end

    def outgoing(type)
      @relationships << { "type" => type.to_s, "direction" => "out" }
      self
    end

    def incoming(type)
      @relationships << { "type" => type.to_s, "direction" => "in" }
      self
    end

    def uniqueness(u)
      @uniqueness = u
      self
    end

    def order(o)
      @order = o
      self
    end

    def filter(body)
      @filter = {
        "language" => "javascript",
        "body"     => body
      }
      self
    end

    def prune(body)
      @prune = {
        "language" => "javascript",
        "body"     => body
      }
      self
    end

    def depth(d)
      d = 2_147_483_647 if d == :all
      @depth = d
      self
    end

    def include_start_node
      @filter = {
        "language" => "builtin",
        "name"     => "all"
      }
      self
    end

    def size
      [*self].size
    end

    alias_method :length, :size

    def [](index)
      each_with_index { |node, i| break node if index == i }
    end

    def empty?
      first.nil?
    end

    def each
      nodes = []
      iterator.each do |i|
        node = @from.class.new(i)
        nodes << node
        yield node
      end
      nodes
    end

    def iterator
      options = {
        "order"         => @order,
        "uniqueness"    => @uniqueness,
        "relationships" => @relationships
      }
      options["prune evaluator"] = @prune  unless @prune.nil?
      options["return filter"]   = @filter unless @filter.nil?
      options["depth"]           = @depth  unless @depth.nil?

      if @relationships[0]["type"].empty?
        rels = rest.get_node_relationships(
          @from.neo_id, @relationships[0]["direction"]) || []
        case @relationships[0]["direction"]
        when "in"
          rels.map { |r| rest.get_node(r["start"]) }
        when "out"
          rels.map { |r| rest.get_node(r["end"]) }
        else
          rels.map do |r|
            if @from.neo_id == r["start"].split('/').last.to_i
              rest.get_node(r["end"])
            else
              rest.get_node(r["start"])
            end
          end
        end
      else
        rest.traverse(@from.neo_id, "nodes", options)
      end
    end
  end
end
