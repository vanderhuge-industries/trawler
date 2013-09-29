module Trawler
  module Stores
    class Bookmark
      include Mongoid::Document
      include Trawler::Stores::Visible

      [:url, :title, :description, :tags, :source_id].each do |f|
        field f, type: String
      end

      field :source, type: Symbol

      field :time, type: DateTime
    end
  end
end

