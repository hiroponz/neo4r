require "aneo/type_converters"

module Aneo
  # Aneo node attributes module
  module Attributes
    extend ActiveSupport::Concern

    # class methods
    module ClassMethods
      # @return [Hash] a hash of all properties and its configuration defined by
      # property class method
      def decl_props
        @decl_props ||= {}
      end

      # make sure the inherited classes inherit the <tt>_decl_props</tt> hash
      def inherited(klass)
        klass.instance_variable_set(:@decl_props, decl_props.clone)
        super
      end

      def property(*args)
        options = args.extract_options!
        args.each do |property_sym|
          property_setup(property_sym, options)
        end
      end

      def to_ruby(hash)
        ret = {}
        hash.each do |k, v|
          if decl_props.key?(k.to_sym)
            ret[k] = decl_props[k.to_sym][:converter].to_ruby(v)
          else
            ret[k] = v
          end
        end
        ret
      end

      def to_java(hash)
        ret = {}
        hash.each do |k, v|
          if decl_props.key?(k.to_sym)
            ret[k] = decl_props[k.to_sym][:converter].to_java(v)
          elsif v
            ret[k] = v
          end
        end
        ret
      end

      protected

      def property_setup(property, options)
        decl_props[property] = options
        handle_property_options_for(property, options)
      end

      def handle_property_options_for(property, options)
        converter = options[:converter] ||
          Aneo::TypeConverters
          .converter(decl_props[property][:type])
        decl_props[property][:converter] = converter
      end
    end
  end
end
