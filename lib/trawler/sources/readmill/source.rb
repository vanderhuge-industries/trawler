module Trawler
  module Sources
    module Readmill
      class Source
        def self.collect(readmill_clientid, readmill_userid)
          fetcher = Fetcher.new(readmill_clientid)
          highlights = fetcher.highlights_for_user(readmill_userid)

          Trawler::Stores::Highlight.save highlights
        end
      end
    end
  end
end
