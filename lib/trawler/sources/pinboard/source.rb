module Trawler
  module Sources
    module Pinboard
      class Source
        # collect will update existing bookmarks in place
        def collect(user, password, count=50)
          json = JsonFetcher.get "https://#{user}:#{password}@api.pinboard.in/v1/posts/recent?count=#{count}&format=json" do |error_response|
            raise "Fetch of Pinboard bookmarks failed. #{error_response}"
          end

          bookmarks_json = json['posts']

          puts "Fetched #{bookmarks_json.length} bookmarks"

          json['posts'].each do |bookmark_json|
            bookmark = Trawler::Sources::Bookmark.find_or_create(bookmark_json['href'])
            bookmark.title       = bookmark_json['description']
            bookmark.description = bookmark_json['extended']
            bookmark.time        = DateTime.parse(bookmark_json['time'])
            bookmark.tags        = bookmark_json['tags']
            bookmark.source      = :pinboard
            bookmark.source_id   = bookmark_json['href']
            bookmark.save!
          end
        end

        # Import will only insert new bookmarks
        def import(bookmarks_json)
          puts "Importing #{bookmarks_json.length} bookmarks"

          save_bookmarks bookmarks_json
        end

        private

        def save_bookmarks(json)
          json['posts'].each do |bookmark_json|
            bookmark = Trawler::Sources::Bookmark.find_or_create(bookmark_json['href']) do |b|
              b.title       = bookmark_json['description']
              b.description = bookmark_json['extended']
              b.time        = DateTime.parse(bookmark_json['time'])
              b.tags        = bookmark_json['tags']
              b.source      = :pinboard
              b.source_id   = bookmark_json['href']
            end
          end
        end
      end
    end
  end
end
