require "spec_helper"
require "ostruct"

describe Trawler::Sources::JsonFetcher do

  describe ".get" do
    let(:response) { OpenStruct.new(code: 200, body: "") }
    let(:raw_json) { {} }

    before(:each) do
      allow(RestClient).to receive(:get).and_return { response }
      allow(JSON).to receive(:parse).and_return { raw_json }
      # Flush Memoist cache
      Trawler::Sources::JsonFetcher.flush_cache
    end

    it "performs a get request on the url" do
      Trawler::Sources::JsonFetcher.get("url")
      expect(RestClient).to have_received(:get)
        .with("url", { accepts: :json })
    end

    it "parses the json response" do
      Trawler::Sources::JsonFetcher.get("url")
      expect(JSON).to have_received(:parse).with("")
    end

    it "returns the parsed highlights" do
      result = Trawler::Sources::JsonFetcher.get("url")
      expect(result).to eq(raw_json)
    end

    context "when there is an error response" do
      let(:response) { OpenStruct.new(code: 500, body: "") }

      it "raises an error" do
        expect { Trawler::Sources::JsonFetcher.get("url")}.to raise_error
      end
    end
  end
end
