module Trawler
  module Stores
    class Book
      include Mongoid::Document

      [:title, :author].each do |f|
        field f, type: String
      end

      field :last_update, type: DateTime

      has_many :highlights
    end
  end
end

