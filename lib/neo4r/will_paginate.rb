require 'will_paginate/collection'
require 'will_paginate/per_page'
require 'neo4r/paginated'

module Neo4r
  # The module provides the common interface for the pagination on any Enumerable class.
  module WillPaginate
    include ::WillPaginate::CollectionMethods

    def paginate(options = {})
      page = options[:page].to_i || 1
      per_page = options[:per_page].to_i || ::WillPaginate.per_page
      ::WillPaginate::Collection.create(page, per_page) do |pager|
        res = ::Neo4r::Paginated.create_from(self, page, per_page)
        pager.replace res.to_a
        pager.total_entries = res.total unless pager.total_entries
      end
    end
  end
end
