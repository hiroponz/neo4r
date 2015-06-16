module Aneo
  # Peoperty container class
  class PropertyContainer < OpenStruct
    include Aneo::Attributes

    attr_reader :neo_id, :rest

    def initialize(args = {})
      @rest = RestWrapper.new
      if args["self"] && args["data"]
        @neo_id = args["self"].split("/").last.to_i
        super(self.class.to_ruby(args["data"]))
      else
        super(args)
      end
    end

    def is_new?
      @neo_id.nil?
    end

    def to_id(target)
      if target.is_a?(String)
        target.split("/").last.to_i
      elsif target.class < PropertyContainer
        target.neo_id
      else
        target
      end
    end

    def inspect
      str = super
      str.sub!(/ /, "[#{@neo_id}] ") unless @neo_id.nil?
      str
    end
  end
end
