module Trawler
  module Fetchers
    class ReadmillParser
      def call(raw_json)

      end

      def highlights_from_json_response(json)

        # TODO First step is to check to see if the highlight already exists
        # and if so skip onto the next item

        json['items'].map do |item|
          #Trawler::Stores::Readmill::Book.new(
            #title:
            #author:
            #last_update
          #)

          Trawler::Stores::Readmill::Highlight.new(
            text: item['content']
            #"highlighted_at"=>"2013-06-21T18:09:10Z"
          )

          # TODO You get to a book from a highlight via a reading
          # https://api.readmill.com/v2/readings/32900
        end

        # TODO if we need to create a highlight we should build up a hash of books to readings.
        # If any of the books don't exist they should be created
        # on the fly and have their last update time updated. (Do I use this??)
      end
    end
  end
end

