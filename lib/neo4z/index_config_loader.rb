# coding: utf-8
module Neo4z
  module IndexConfigLoader
    #
    # Load index config from database.
    #
    class << self
      # entry point.
      def load_index_config(mod)
        if ExperimentKlass.table_exists?
          ExperimentKlass.all.each do |klass|
            klass.props.each do |prop|
              prop_key = prop.mnemonic.to_sym
              if prop.is_a?(Property::String)
                mod.index prop_key, field_type: String
              elsif prop.is_a?(Property::Number)
                mod.index prop_key, field_type: Float
              elsif prop.is_a?(Property::Date)
                mod.index prop_key, field_type: Date
              elsif prop.is_a?(Property::DateTime)
                mod.index prop_key, field_type: DateTime
              end
            end
          end
        end
      end

      def included(mod)
        load_index_config(mod)
      end

    end

  end
end
