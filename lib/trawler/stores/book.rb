module Trawler
  module Stores
    class Book
      include Mongoid::Document
      include Trawler::Stores::Visible

      [:title, :author, :source_id, :cover_url].each do |f|
        field f, type: String
      end

      field :source, type: Symbol

      field :last_update, type: DateTime

      has_many :highlights

      def self.find_or_create(title, &on_create)
        book = self.where(title: title).first

        return book if book

        self.new(title: title).tap do |b|
          on_create.call(b) if on_create
          b.save!
        end
      end
    end
  end
end

