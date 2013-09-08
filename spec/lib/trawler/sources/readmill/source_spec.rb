require "spec_helper"

describe Trawler::Sources::Readmill::Source do
  describe ".collect" do

    let(:fetcher)   { double(Trawler::Sources::Readmill::Fetcher) }
    let(:fetched_highlights) { [] }
    let(:client_id) { "client" }
    let(:user_id)   { "user" }

    before(:each) do
      allow(Trawler::Sources::Readmill::Fetcher).to receive(:new) { fetcher }
      allow(fetcher).to receive(:highlights_for_user) { fetched_highlights }

      allow(Trawler::Stores::Highlight).to receive(:save)

      Trawler::Sources::Readmill::Source.collect(client_id, user_id)
    end

    it "creates a fetcher" do
      expect(Trawler::Sources::Readmill::Fetcher).to have_received(:new).with(client_id)
    end

    it "fetches highlights for the user" do
      expect(fetcher).to have_received(:highlights_for_user).with(user_id)
    end

    it "stores the fetched highlights" do
      expect(Trawler::Stores::Highlight).to have_received(:save).with(fetched_highlights)
    end
  end
end
