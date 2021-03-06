module Trawler
  module Stores
    class Highlight
      include Mongoid::Document
      include Mongoid::Timestamps
      include Trawler::Stores::Visible

      field :text, type: String
      field :date, type: DateTime

      field :source, type: Symbol
      field :source_id, type: String

      belongs_to :book

      default_scope -> { desc(:created_at) }

      def self.find_or_create(text, &on_create)
        highlight = self.where(text: text).first

        return highlight if highlight

        self.new(text: text).tap do |h|
          on_create.call(h) if on_create
          h.save!
        end
      end
    end
  end
end

