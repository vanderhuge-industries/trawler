module Trawler
  module Sources
    module Readmill
      class Source
        def initialize(readmill_clientid)
          @fetcher = Fetcher.new(readmill_clientid)
        end

        def collect(readmill_userid)
          highlights = @fetcher.highlights_for_user(readmill_userid)
          save_highlights highlights
        end

        def import(readmill_userid)
          highlights = @fetcher.all_highlights_for_user(readmill_userid)
          save_highlights highlights
        end

      private

        def save_highlights(highlights)
          add_readings_to_highlights(highlights)

          highlights.each do |h|
            bjson = h.book

            book = Trawler::Stores::Book.find_or_create(bjson.title) do |new_book|
              new_book.author    = bjson.author
              new_book.cover_url = bjson.cover_url
              new_book.source    = bjson.source
              new_book.source_id = bjson.source_id
            end

            # TODO Set the book's last_update time

            Trawler::Stores::Highlight.find_or_create(h.text) do |new_highlight|
              new_highlight.source_id = h.source_id
              new_highlight.source    = h.source
              new_highlight.text      = h.text
              new_highlight.date      = h.date
              new_highlight.book      = book
            end
          end
        end

        def add_readings_to_highlights(highlights)
          highlights.each do |highlight|
            book = @fetcher.book_for_reading(highlight.reading_id)
            highlight.book = book
          end
        end
      end
    end
  end
end
