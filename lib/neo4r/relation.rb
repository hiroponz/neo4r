require "neo4r/will_paginate"
require "neo4r/rest_wrapper"

module Neo4r
  # Neo4r relation class
  class Relation
    include Enumerable
    include ::Neo4r::WillPaginate

    alias_method :all, :to_a
    alias_method :size, :count

    def initialize(klass)
      @klass = klass
      @labels = klass.name.split("::")
      @props = {}
      @has = []
      @order_by = []
      @limit = nil
      @offset = nil
    end

    def clear
      @labels = []
      @props = {}
      @has = []
      @order_by = []
      @limit = nil
      @offset = nil
      self
    end

    def count
      rest = RestWrapper.new
      rest.execute_query(to_cypher(return: :count))["data"].first.first
    end

    def each
      rest = RestWrapper.new
      data = rest.execute_query(to_cypher)["data"]
      data.map do |d|
        yield @klass.new(d.first)
      end
    end

    def labels(*labels)
      @labels.concat(labels).uniq!
      self
    end

    def where(hash)
      @props.merge!(hash)
      self
    end

    def asc(*props)
      props.each do |prop|
        @order_by << "a.#{prop}"
      end
      self
    end

    def desc(*props)
      props.each do |prop|
        @order_by << "a.#{prop} DESC"
      end
      self
    end

    def limit(n)
      @limit = n
      self
    end

    def offset(n)
      @offset = n
      self
    end

    def has(*props)
      @has.concat(props).uniq!
      self
    end

    def to_cypher(options = {})
      [
        to_match,
        to_where,
        to_return(options),
        to_order_by(options),
        to_skip(options),
        to_limit(options)
      ].compact.join("\n")
    end

    private

    def to_match
      "MATCH (a#{to_labels}#{to_props})"
    end

    def to_labels
      @labels.reduce("") do |result, label|
        result + ":#{label}"
      end
    end

    def to_props
      format_props = @props.map do |name, value|
        "#{name}: #{format_value(value)}"
      end.join(", ")

      if format_props.length > 0
        " {#{format_props}}"
      else
        ""
      end
    end

    def format_value(value)
      case value
      when String
        '"' + value.gsub('"', '\"') + '"'
      else
        value.to_s
      end
    end

    def to_return(options)
      case options[:return]
      when :count
        "RETURN count(a)"
      else
        "RETURN a"
      end
    end

    def to_order_by(options)
      if @order_by.length > 0 && options[:return].nil?
        "ORDER BY " + @order_by.join(", ")
      else
        nil
      end
    end

    def to_skip(options)
      if @offset && options[:return].nil?
        "SKIP #{@offset}"
      else
        nil
      end
    end

    def to_limit(options)
      if @limit && options[:return].nil?
        "LIMIT #{@limit}"
      else
        nil
      end
    end

    def to_where
      expr = @has.map do |prop|
        "HAS (a.#{prop})"
      end.join(" AND ")

      if expr.length > 0
        "WHERE #{expr}"
      else
        nil
      end
    end
  end
end
