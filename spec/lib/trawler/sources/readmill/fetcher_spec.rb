require "spec_helper"
require "ostruct"

describe Trawler::Sources::Readmill::Fetcher do

  let(:client_id) { "client-id" }
  let(:parser) { double("parser", highlights_from_json: parsed_highlights) }
  let(:parsed_highlights) { [] }
  let(:fetcher) { Trawler::Sources::Readmill::Fetcher.new(client_id, parser) }

  describe "#highlights_for_user" do
    let(:response) { OpenStruct.new(code: 200, parsed_response: {}) }

    before(:each) do
      allow(HTTParty).to receive(:get).and_return { response }
    end

    context "when there is an error response" do
      let(:response) { OpenStruct.new(code: 500, parsed_response: {}) }

      it "raises an error" do
        expect { fetcher.highlights_for_user("user-id")}.to raise_error
      end
    end

    it "fetches highlights from Readmill for the user via HTTP" do
      fetcher.highlights_for_user("user-id")
      expect(HTTParty).to have_received(:get).with("https://api.readmill.com/v2/users/user-id/highlights?client_id=client-id&count=100")
    end

    it "parses the json response" do
      fetcher.highlights_for_user("user-id")
      expect(parser).to have_received(:highlights_from_json).with({})
    end

    it "returns the parsed highlights" do
      result = fetcher.highlights_for_user("user-id")
      expect(result).to eq parsed_highlights
    end
  end
end
