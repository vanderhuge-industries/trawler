module Trawler
  module Sources
    module Readmill
      class Parser
        def highlights_from_json(json)
          json['items'].map {|i| i['highlight'] }.map do |hl|
            OpenStruct.new({
              remote_id: hl['id'].to_s,
              source: :readmill,
              text: hl['content'],
              date: DateTime.parse(hl['highlighted_at']),
              reading_id: hl['reading']['id']
            })
          end
        end

        def book_from_reading_json(json)
          book = json['reading']['book']
          OpenStruct.new(
            remote_id: book['id'].to_s,
            source: :readmill,
            title: book['title'],
            author: book['author'],
            cover_url: book['cover_url']
          )
        end
      end
    end
  end
end

