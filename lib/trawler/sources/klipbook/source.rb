module Trawler
  module Sources
    module Klipbook
      class Source
        def import(books_json)
          puts "Importing highlights from #{books_json.length} books"

          books_json.each do |book_json|
            book = Trawler::Stores::Book.where(
              title: book_json['title'],
              author: book_json['author'],
              source: :klipbook,
              source_id: book_json['asin']
            ).first_or_create

            puts "Importing #{book_json['title']}"
            book.last_update = DateTime.parse(book_json['last_update'])
            book.save

            highlights = book_json['clippings']
              .select { |json_h| json_h['type'] == 'highlight' }
              .map do |json_h|
                Trawler::Stores::Highlight.new.tap do |highlight|
                  highlight.text = json_h['text']
                  highlight.source = :klipbook
                  highlight.source_id = json_h['annotation_id']
                  highlight.book = book
                end
              end
            highlights.each(&:save)
          end
        end
      end
    end
  end
end
