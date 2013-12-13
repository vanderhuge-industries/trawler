require 'spec_helper'

describe Trawler::Stores::Bookmark do
  it { should have_fields(:url, :title, :description, :tags, :time, :source, :source_id, :hidden) }

  describe ".find_or_create" do
    context "with no existing books" do
      let!(:existing_book) {}

      it "creates a new book" do
        new_book = Trawler::Stores::Book.find_or_create "book title"
        expect(new_book).to be
        expect(Trawler::Stores::Book.count).to eq 1
      end

      it "calls the provided block" do
        new_book = Trawler::Stores::Book.find_or_create "book title" do |b|
          b.author = "some author"
        end

        expect(new_book.author).to eq "some author"
      end
    end

    context "with an existing book" do
      let!(:existing_book) do
        Trawler::Stores::Book.create(
          title: "book title",
          source: :readmill,
          source_id: "1")
      end

      it "returns the existing book" do
        book = Trawler::Stores::Book.find_or_create "book title"
        expect(book).to eq existing_book
      end
    end
  end
end
