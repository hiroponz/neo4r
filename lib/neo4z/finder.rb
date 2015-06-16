require "aneo/relation"

module Aneo
  # Aneo Finder module
  module Finder
    def find(neo_id)
      rest = RestWrapper.new
      node = rest.get_node(neo_id)
      new(node)
    end

    def find_by_query(query)
      rest = RestWrapper.new
      ret = rest.execute_query(query)
      ret["data"].map do |data|
        cols = []
        data.each do |col|
          cols << new(col)
        end
        if cols.size == 1
          cols.first
        else
          cols
        end
      end
    end

    def labels(*labels)
      relation.labels(*labels)
    end

    def where(hash)
      relation.where(hash)
    end

    def asc(*props)
      relation.asc(*props)
    end

    def desc(*props)
      relation.desc(*props)
    end

    def limit(n)
      relation.limit(n)
    end

    def offset(n)
      relation.offset(n)
    end

    def all
      relation.all
    end

    def first
      relation.first
    end

    def count
      relation.count
    end

    def relation
      Relation.new(self)
    end
  end
end
