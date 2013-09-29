module Trawler
  module Stores
    class Book
      include Mongoid::Document
      include Trawler::Stores::Visible

      [:title, :author, :source_id, :cover_url].each do |f|
        field f, type: String
      end

      field :source, type: Symbol

      field :last_update, type: DateTime

      has_many :highlights
    end
  end
end

