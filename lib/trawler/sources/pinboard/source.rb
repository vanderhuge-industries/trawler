module Trawler
  module Sources
    module Pinboard
      class Source
        def import(bookmarks_json)
          bookmarks_json.map do |bookmark_json|
            Trawler::Stores::Bookmark.new.tap do |bookmark|
              bookmark.url = bookmark_json['href']
              bookmark.title = bookmark_json['description']
              bookmark.description = bookmark_json['extended']
              bookmark.time = DateTime.parse(bookmark_json['time'])
              bookmark.tags = bookmark_json['tags']
              bookmark.source = :pinboard
              bookmark.source_id = bookmark_json['href']
            end
          end.each(&:save)
        end
      end
    end
  end
end
