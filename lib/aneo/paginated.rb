module Aneo
  # The class provides the pagination based on the given source.
  # The source must be an Enumerable implementing methods drop,
  # first and count (or size).
  # This can be used to paginage any Enumerable collection and
  # provides the integration point for other gems, like
  # will_paginate and kaminari.
  class Paginated
    include Enumerable
    attr_accessor :items, :total, :current_page
    delegate :each, to: :items

    def initialize(items, total, current_page)
      @items = items
      @total = total
      @current_page = current_page
    end

    def self.create_from(source, page, per_page)
      dup = source.dup
      partial = dup.offset((page - 1) * per_page).limit(per_page)
      Paginated.new(partial, dup.count, page)
    end
  end
end
