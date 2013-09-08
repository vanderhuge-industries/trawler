module Trawler
  module Stores
    class Highlight
      include Mongoid::Document

      field :text, type: String

      belongs_to :book
    end
  end
end

