require "spec_helper"

describe Trawler::Sources::Readmill::Source do

  let(:source) { Trawler::Sources::Readmill::Source.new(client_id) }

  describe "#collect" do

    let(:fetcher)   { double(Trawler::Sources::Readmill::Fetcher) }
    let(:fetched_highlights) {
      [
        OpenStruct.new(
          text: "highlight1",
          source: :readmill,
          source_id: "1",
          date: nil,
          reading_id: "reading1"
        ),
        OpenStruct.new(
          text: "highlight2",
          source: :readmill,
          source_id: "2",
          date: nil,
          reading_id: "reading2"
        )
      ]
    }
    let(:client_id) { "client" }
    let(:user_id)   { "user" }
    let(:book)      {
      OpenStruct.new(
        title: "my title",
        author: "author",
        source: :readmill,
        source_id: "2"
      )
    }

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
      expect(Trawler::Stores::Highlight.count).to eq 2
      expect(Trawler::Stores::Book.count).to eq 1
    end
  end
end
