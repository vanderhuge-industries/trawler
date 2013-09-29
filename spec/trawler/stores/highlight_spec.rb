require 'spec_helper'
require 'ostruct'

describe Trawler::Stores::Highlight do
  it { should have_fields(:text, :source, :source_id, :hidden) }
  it { should belong_to(:book) }

  describe ".save" do
    let(:book) { OpenStruct.new(title: "Test Book",
                                source: :readmill,
                                source_id: "1",
                                author: "Test Author",
                                cover_url: "Url") }

    let(:highlight) { OpenStruct.new(text: "Test Text",
                                     source: :readmill,
                                     source_id: "2",
                                     date: DateTime.new(2013, 10, 10),
                                     book: book) }

    # Ensure these are triggered before the before each block in all below contexts
    let!(:existing_book) {}
    let!(:existing_highlight) {}

    before(:each) do
      Trawler::Stores::Highlight.save [highlight]
      @highlights = Trawler::Stores::Highlight.all.to_a
      @books = Trawler::Stores::Book.all.to_a
    end

    context "with no existing books or highlights" do
      let!(:existing_book) {}
      let!(:existing_highlight) {}

      it "creates each of the books and highlights passed in" do
        expect(@highlights.length).to eq 1
        expect(@highlights.first.text).to eq "Test Text"
        expect(@highlights.first.source).to eq :readmill
        expect(@highlights.first.source_id).to eq "2"
        expect(@highlights.first.date).to eq DateTime.new(2013, 10, 10)
        expect(@highlights.first.book).to eq @books.first

        expect(@books.length).to eq 1
        expect(@books.first.title).to eq "Test Book"
        expect(@books.first.source).to eq :readmill
        expect(@books.first.source_id).to eq "1"
        expect(@books.first.author).to eq "Test Author"
        expect(@books.first.cover_url).to eq "Url"
      end
    end

    context "with an existing book" do
      let!(:existing_book) {
        Trawler::Stores::Book.create(
                  title: "Test Book",
                  source: :readmill,
                  source_id: "1",
                  author: "Test Author",
                  cover_url: "Url"
                )
      }

      it "creates the missing highlight" do
        expect(@highlights.length).to eq 1
        expect(@highlights.first.text).to eq "Test Text"
        expect(@highlights.first.source).to eq :readmill
        expect(@highlights.first.source_id).to eq "2"
        expect(@highlights.first.date).to eq DateTime.new(2013, 10, 10)
        expect(@highlights.first.book).to eq existing_book

        expect(@books.length).to eq 1
        expect(@books.first).to eq existing_book
      end
    end

    context "with an existing book and highlight" do
      let!(:existing_book) {
        Trawler::Stores::Book.create(
                  title: "Test Book",
                  source: :readmill,
                  source_id: "1",
                  author: "Test Author",
                  cover_url: "Url"
                )
      }

      let!(:existing_highlight) {
        Trawler::Stores::Highlight.create(
                  text: "Test Text",
                  source: :readmill,
                  source_id: "2",
                  date: DateTime.new(2013, 10, 10),
                  book: existing_book
                )
      }

      it "does not create any new highlights or books" do
        expect(@highlights).to eq [ existing_highlight ]
        expect(@books).to eq [ existing_book ]
      end
    end
  end
end
