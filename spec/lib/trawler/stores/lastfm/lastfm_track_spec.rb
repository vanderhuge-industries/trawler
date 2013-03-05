require 'spec_helper'

describe Trawler::Stores::Lastfm::Track do
  it { should have_field(:event_timestamp) }

  it { should have_fields(:name, :artist_name, :album_name) }
  it { should have_field(:url) }
  it { should have_field(:played_datetime) }

  describe 'thumbnails' do
    it { should embed_many(:thumbnails) }

    describe 'thumbnails of a certain size' do
      let(:small_thumbnail_name) { 'small_thumbnail.png' }
      let(:track) { Trawler::Stores::Lastfm::Track.create }
      let(:certain_size) { :small }

      before { track.thumbnails.create(size: certain_size, url: small_thumbnail_name) }

      it 'can be accessed' do
        track.thumbnail(certain_size).should == small_thumbnail_name
      end
    end
  end

  describe 'the latest timestamp' do
    let(:latest_time) { Time.now.to_i }

    let!(:newest_track) { Trawler::Stores::Lastfm::Track.create(event_timestamp: latest_time) }
    let!(:older_track) { Trawler::Stores::Lastfm::Track.create(event_timestamp: Time.now - 3) }

    it 'is the timestamp of the newest track' do
      Trawler::Stores::Lastfm::Track.latest_timestamp.should == latest_time
    end
  end
end
