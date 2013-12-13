require 'json'

module Trawler
  module Sources
    module Klipbook
      class Source
        def collect(access_token)
          contents, _ = Trawler::Dropbox::FileReader.new(access_token).read_file "/klipbook.json"

          books_json = JSON.parse contents

          puts "Collecting highlights from #{books_json.length} books"
          save_books(books_json)
        end

        def import(books_json)
          puts "Importing highlights from #{books_json.length} books"
          save_books(books_json)
        end

      private

        def save_books(books_json)
          books_json.each do |bjson|
            book = Trawler::Stores::Book.find_or_create(bjson['title']) do |b|
              puts "Importing #{bjson['title']}"

              b.author      = bjson['author']
              b.source      = :klipbook
              b.source_id   = bjson['asin']
              b.last_update = DateTime.parse(bjson['last_update'])
            end

            highlights = bjson['clippings']
              .select { |hjson| hjson['type'] == 'highlight' }
              .each do |hjson|
                Trawler::Stores::Highlight.find_or_create(hjson['text']) do |h|
                  h.source = :klipbook
                  h.source_id = hjson['annotation_id']
                  h.book = book
                end
              end
          end
        end
      end
    end
  end
end
