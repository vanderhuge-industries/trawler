require "spec_helper"

describe Trawler::Sources::Readmill::Source do

  let(:source) { Trawler::Sources::Readmill::Source.new(client_id) }

  describe "#collect" do

    let(:fetcher)   { double(Trawler::Sources::Readmill::Fetcher) }
    let(:fetched_highlights) { [
      OpenStruct.new(reading_id: "reading1"),
      OpenStruct.new(reading_id: "reading2")
    ]
    }
    let(:client_id) { "client" }
    let(:user_id)   { "user" }
    let(:book)      { double("book") }

    before(:each) do
      allow(Trawler::Sources::Readmill::Fetcher).to receive(:new) { fetcher }
      allow(fetcher).to receive(:highlights_for_user) { fetched_highlights }
      allow(fetcher).to receive(:book_for_reading).and_return { book }

      allow(Trawler::Stores::Highlight).to receive(:save)

      source.collect(user_id)
    end

    it "creates a fetcher" do
      expect(Trawler::Sources::Readmill::Fetcher).to have_received(:new).with(client_id)
    end

    it "fetches highlights for the user" do
      expect(fetcher).to have_received(:highlights_for_user).with(user_id)
    end

    it "fetches books for each of the returned highlights" do
      expect(fetcher).to have_received(:book_for_reading).with("reading1")
      expect(fetcher).to have_received(:book_for_reading).with("reading2")
    end

    it "stores the fetched highlights and books" do
      expect(Trawler::Stores::Highlight).to have_received(:save).with([
        OpenStruct.new(reading_id: "reading1", book: book),
        OpenStruct.new(reading_id: "reading2", book: book)
      ]
      )
    end
  end
end
