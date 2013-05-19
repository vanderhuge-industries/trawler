module Trawler
  module Stores
    module Readmill
      class Book
        include Mongoid::Document

        [:title, :author].each do |f|
          field f, type: String
        end

        field :last_update, type: DateTime

        has_many :highlights
      end

      class Highlight
        include Mongoid::Document

        field :text, type: String

        belongs_to :book
      end
    end
  end
end



