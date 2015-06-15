require "aneo/node_traverser"
require "aneo/relationship_traverser"

module Aneo
  # Node relationship module
  module NodeRelationship
    DIRECTIONS = %W(incoming, in, outgoing, out, all, both)

    def outgoing(types = nil)
      NodeTraverser.new(self).outgoing(types)
    end

    def incoming(types = nil)
      NodeTraverser.new(self).incoming(types)
    end

    def both(types = nil)
      NodeTraverser.new(self).both(types)
    end

    def rels(*types)
      RelationshipTraverser.new(self, types, :both)
    end

    def rel(dir, type)
      rel = RelationshipTraverser.new(self, type, dir)
      rel = rel.first unless rel.empty?
      rel
    end

    def rel?(dir = nil, type = nil)
      if DIRECTIONS.include?(dir.to_s)
        !rest.get_node_relationships(self, dir, type).empty?
      else
        !rest.get_node_relationships(self, type, dir).empty?
      end
    end
  end
end
