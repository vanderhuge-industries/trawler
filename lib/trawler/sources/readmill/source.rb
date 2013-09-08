module Trawler
  module Sources
    module Readmill
      class Source
        def initialize(readmill_clientid)
          @fetcher = Fetcher.new(readmill_clientid)
        end

        def collect(readmill_userid)
          highlights = @fetcher.highlights_for_user(readmill_userid)

          add_readings_to_highlights(highlights)

          Trawler::Stores::Highlight.save highlights
        end

      private

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
