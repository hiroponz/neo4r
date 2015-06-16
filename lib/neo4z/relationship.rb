module Neo4z
  class Relationship < PropertyContainer
    def self.create(args)
      rel = Relationship.new(args)
      if rel.save
        rel
      else
        nil
      end
    end

    attr_reader :start_node_id, :end_node_id, :rel_type

    def initialize(args)
      super(args)
      if is_new?
        @start_node_id = to_id(delete_field(:start))
        @end_node_id = to_id(delete_field(:end))
        @rel_type = delete_field(:type)
      else
        @start_node_id = to_id(args["start"])
        @end_node_id = to_id(args["end"])
        @rel_type = args["type"]
      end
    end

    def save
      if is_new?
        rel = rest.create_relationship(
          @rel_type, @start_node_id, @end_node_id, @table)
        @neo_id = rel["self"].split("/").last.to_i
      else
        rest.reset_relationship_properties(@neo_id, @table)
      end
      true
    end

    def destroy
      rest.delete_relationship(neo_id)
      true
    end

    def start_node
      @start_node ||= Experiment.find(@start_node_id)
    end

    def end_node
      @end_node ||= Experiment.find(@end_node_id)
    end
  end
end
