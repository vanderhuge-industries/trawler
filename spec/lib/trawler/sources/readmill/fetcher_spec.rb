require "spec_helper"
require "ostruct"

describe Trawler::Sources::Readmill::Fetcher do

  let(:client_id) { "client-id" }
  let(:parser) { double("parser", highlights_from_json: parsed_highlights) }
  let(:raw_json) { double }
  let(:parsed_highlights) { [] }
  let(:fetcher) { Trawler::Sources::Readmill::Fetcher.new(client_id, parser) }

  describe "#highlights_for_user" do
    let(:response) { OpenStruct.new(code: 200, body: "") }

    before(:each) do
      allow(JSON).to receive(:parse).and_return { raw_json }
      allow(RestClient).to receive(:get).and_return { response }
    end

    context "when there is an error response" do
      let(:response) { OpenStruct.new(code: 500, body: "") }

      it "raises an error" do
        expect { fetcher.highlights_for_user("user-id")}.to raise_error
      end
    end

    it "fetches highlights from Readmill for the user via HTTP" do
      fetcher.highlights_for_user("user-id")
      expect(RestClient).to have_received(:get).with("https://api.readmill.com/v2/users/user-id/highlights?client_id=client-id&count=100")
    end

    it "parses the json response and passes it to the highlight parser" do
      fetcher.highlights_for_user("user-id")
      expect(JSON).to have_received(:parse).with("")
      expect(parser).to have_received(:highlights_from_json).with(raw_json)
    end

    it "returns the parsed highlights" do
      result = fetcher.highlights_for_user("user-id")
      expect(result).to eq parsed_highlights
    end
  end
end
