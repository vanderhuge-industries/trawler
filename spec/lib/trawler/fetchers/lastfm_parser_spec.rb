require 'spec_helper'

describe Trawler::Fetchers::LastfmParser do
  describe 'mapping Last.fm data for local persistence' do
    let(:timestamp) { "12345678" }
    let(:date) { { "uts" => timestamp, "content" => DateTime.now.to_s } }
    let(:fetched_track) do
      {
        "date" => date
      }
    end

    it 'uses date.uts as the events timestamp' do
      Trawler::Stores::Lastfm::Track.should_receive(:create).
        with(hash_including(event_timestamp: timestamp))
      Trawler::Fetchers::LastfmParser.parse([ fetched_track ])
    end
  end
end
