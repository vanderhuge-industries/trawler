module Trawler
  module Stores
    class Highlight
      include Mongoid::Document
      include Trawler::Stores::Visible

      field :text, type: String

      field :source, type: Symbol
      field :source_id, type: String

      belongs_to :book

      def self.save(highlights)
        highlights.map do |h|
          b = h.book
          book = Trawler::Stores::Book.where(
            title: b.title,
            author: b.author,
            cover_url: b.cover_url,
            source: b.source,
            source_id: b.source_id
          ).first_or_create

          Trawler::Stores::Highlight.where(
            source_id: h.source_id,
            source: h.source,
            text: h.text,
            date: h.date,
            book: book
          ).first_or_create
        end

        # TODO Set last updated on the book itself
      end
    end
  end
end

