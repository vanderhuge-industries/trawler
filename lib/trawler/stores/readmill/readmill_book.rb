module Trawler
  module Stores
    module Readmill
      class Book
        include Mongoid::Document

        [:title, :author].each do |f|
          field f, type: String
        end

        field :last_update, type: DateTime

        embeds_many :highlights

      end

      class Highlight
        include Mongoid::Document

        field :text, type: String

        embedded_in :book
      end
    end
  end
end



