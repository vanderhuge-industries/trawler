module Trawler
  module Sources
    module Pinboard
      class Source
        def collect(user, password, count=50)
          json = JsonFetcher.get "https://#{user}:#{password}@api.pinboard.in/v1/posts/recent?count=#{count}&format=json" do |error_response|
            raise "Fetch of Pinboard bookmarks failed. #{error_response}"
          end

          puts "Fetched #{json['posts'].length} bookmarks"

          json['posts'].map do |bookmark_json|
            bookmark = Trawler::Stores::Bookmark.where(
              url: bookmark_json['href'],
              title: bookmark_json['description'],
              description: bookmark_json['extended'],
              time: DateTime.parse(bookmark_json['time']),
              tags: bookmark_json['tags'],
              source: :pinboard,
              source_id: bookmark_json['href']
            ).first_or_create
          end
        end


        def import(bookmarks_json)
          puts "Importing #{bookmarks_json.length} bookmarks"

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
