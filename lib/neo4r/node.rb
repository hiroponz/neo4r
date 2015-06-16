require "neo4r/finder"
require "neo4r/property_container"
require "neo4r/node_relationship"

module Neo4r
  # Neo4r Node class
  class Node < PropertyContainer
    extend Finder
    include ActiveModel::Conversion
    include NodeRelationship

    property :created_at, type: DateTime
    property :updated_at, type: DateTime

    def self.create(args)
      node = new(args)
      if node.save
        node
      else
        nil
      end
    end

    def labels
      self.class.name.split("::")
    end

    def labels=(labels)
      fail "Can not change label!"
    end

    def save
      time = DateTime.now
      @table[:created_at] = time if is_new?
      @table[:updated_at] = time
      data = self.class.to_java(@table)
      if is_new?
        node = rest.create_node(data)
        @neo_id = node["self"].split("/").last.to_i
      else
        rest.reset_node_properties(@neo_id, data)
      end
      rest.set_label(@neo_id, labels)
      true
    end

    def destroy
      rest.delete_node!(@neo_id)
      @neo_id = nil
      @table = {}
      true
    end
  end
end
