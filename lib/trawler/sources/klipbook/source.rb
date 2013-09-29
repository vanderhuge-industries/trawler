module Trawler
  module Sources
    module Klipbook
      class Source
        def import(books_json)
          books_json.each do |book_json|
            book = Trawler::Stores::Book.new.tap do |book|
              book.title  = book_json['title']
              book.author = book_json['author']
              book.source = :klipbook
              book.source_id = book_json['asin']
              book.last_update = DateTime.parse(book_json['last_update'])
              book.highlights = book_json['clippings']
                .select { |json_h| json_h['type'] == 'highlight' }
                .map do |json_h|
                  Trawler::Stores::Highlight.new.tap do |highlight|
                    highlight.text = json_h['text']
                    highlight.source = :klipbook
                    highlight.source_id = json_h['annotation_id']
                  end
                end
            end
            book.save
            book.highlights.each(&:save)
          end
        end
      end
    end
  end
end
