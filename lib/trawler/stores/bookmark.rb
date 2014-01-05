module Trawler
  module Stores
    class Bookmark
      include Mongoid::Document
      include Mongoid::Timestamps
      include Trawler::Stores::Visible

      default_scope -> { desc(:time) }

      [:url, :title, :description, :tags, :source_id].each do |f|
        field f, type: String
      end

      field :source, type: Symbol

      field :time, type: DateTime

      def self.find_or_create(url, &on_create)
        bookmark = self.where(url: url).first

        return bookmark if bookmark

        self.new(url: url).tap do |b|
          on_create.call(b) if on_create
          b.save!
        end
      end
    end
  end
end

