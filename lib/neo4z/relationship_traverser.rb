require "aneo/relationship"

module Aneo
  # Relationship traverser class
  class RelationshipTraverser
    include Enumerable

    attr_reader :rest

    def initialize(node, types, direction)
      @rest = RestWrapper.new
      @node      = node
      @types     = [types]
      @direction = direction
    end

    def to_s
      if @types.size == 1 && !@types.empty?
        "#{self.class} [type: #{@type} dir:#{@direction}]"
      elsif !@types.empty?
        "#{self.class} [types: #{@types.join(',')} dir:#{@direction}]"
      else
        "#{self.class} [types: ANY dir:#{@direction}]"
      end
    end

    def each
      rels = []
      iterator.each do |i|
        rel = Relationship.new(i)
        rels << rel
        yield rel if match_to_other?(rel)
      end
      rels
    end

    def empty?
      first.nil?
    end

    def iterator
      Array(rest.get_node_relationships(@node.neo_id, @direction, @types))
    end

    def match_to_other?(rel)
      if @to_other.nil?
        true
      elsif @direction == :outgoing
        rel.end_node_id == @to_other.neo_id
      elsif @direction == :incoming
        rel.start_node_id == @to_other.neo_id
      else
        rel.start_node_id == @to_other.neo_id || rel.end_node_id == @to_other.neo_id
      end
    end

    def to_other(to_other)
      @to_other = to_other
      self
    end

    def destroy
      each { |rel| rel.destroy }
    end

    def size
      [*self].size
    end

    def both
      @direction = :both
      self
    end

    def incoming
      @direction = :incoming
      self
    end

    def outgoing
      @direction = :outgoing
      self
    end

  end
end
