require "spec_helper"
require "ostruct"

describe Trawler::Sources::Readmill::Fetcher do

  let(:client_id) { "client-id" }
  let(:parser) { double("parser", highlights_from_json: parsed_highlights, book_from_reading_json: parsed_book) }
  let(:raw_json) {
    {
      "pagination" => {
        "next" => "https://api.readmill.com/v2/users/2292/highlights?client_id=7c5a0fbcd6948a9cdf8e9156ed31c5a0&cou"
      },
      "items" => []
    }
  }
  let(:parsed_highlights) { double }
  let(:parsed_book) { double }

  let(:fetcher) { Trawler::Sources::Readmill::Fetcher.new(client_id, parser) }

  describe "#highlights_for_user" do
    let(:response) { OpenStruct.new(code: 200, body: "") }

    before(:each) do
      allow(RestClient).to receive(:get).and_return { response }
      allow(RestClient).to receive(:enable)
      allow(JSON).to receive(:parse).and_return { raw_json }
    end

    context "when there is an error response" do
      let(:response) { OpenStruct.new(code: 500, body: "") }

      it "raises an error" do
        expect { fetcher.highlights_for_user("user-id")}.to raise_error
      end
    end

    it "fetches highlights from Readmill for the user via HTTP" do
      fetcher.highlights_for_user("user-id")
      expect(RestClient).to have_received(:get)
        .with("https://api.readmill.com/v2/users/user-id/highlights?client_id=client-id&count=100", { accepts: :json })
    end

    it "parses the json response and passes it to the highlight parser" do
      fetcher.highlights_for_user("user-id")
      expect(JSON).to have_received(:parse).with("")
      expect(parser).to have_received(:highlights_from_json).with(raw_json)
    end

    it "returns the parsed highlights" do
      result = fetcher.highlights_for_user("user-id")
      expect(result).to eq(parsed_highlights)
    end
  end

  describe "#book_for_reading" do
    let(:response) { OpenStruct.new(code: 200, body: "") }

    before(:each) do
      allow(RestClient).to receive(:get).and_return { response }
      allow(JSON).to receive(:parse).and_return { raw_json }
    end

    context "when there is an error response" do
      let(:response) { OpenStruct.new(code: 500, body: "") }

      it "raises an error" do
        expect { fetcher.book_for_reading("reading-id")}.to raise_error
      end
    end

    it "fetches highlights from Readmill for the user via HTTP" do
      fetcher.book_for_reading("reading-id")
      expect(RestClient).to have_received(:get)
        .with("https://api.readmill.com/v2/readings/reading-id?client_id=client-id", { accepts: :json })
    end

    it "parses the json response and passes it to the highlight parser" do
      fetcher.book_for_reading("reading-id")
      expect(JSON).to have_received(:parse).with("")
      expect(parser).to have_received(:book_from_reading_json).with(raw_json)
    end

    it "returns the parsed book" do
      result = fetcher.book_for_reading("reading-id")
      expect(result).to eq(parsed_book)
    end
  end
end
