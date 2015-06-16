module Aneo
  # REST API proxy class
  class RestWrapper
    @@rest = Neography::Rest.new
    def method_missing(name, *args, &block)
      # Create rest object everytyime to avoid exception
      @@rest.__send__ name, *args, &block
    end
  end
end
