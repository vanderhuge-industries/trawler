module Trawler
  module Stores
    class Highlight
      include Mongoid::Document

      field :text, type: String

      field :source, type: Symbol

      belongs_to :book
    end
  end
end

