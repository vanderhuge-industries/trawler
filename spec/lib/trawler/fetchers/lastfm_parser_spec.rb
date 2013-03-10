require 'spec_helper'

describe Trawler::Fetchers::LastfmParser do
  describe 'mapping Last.fm data for local persistence' do
    let(:track) do
      {
        'date' => { 'uts' => '12345678', 'content' => DateTime.now.to_s },
        'name' => 'Year of the Glad',
        'album' => { 'content' => 'The Chronicles of Marnia' },
        'artist' => { 'content' => 'Marnie Stern' },
        'url' => 'http://last.fm/chronicles_of_marnia/'
      }
    end

    describe 'basic attributes' do

      subject { Trawler::Stores::Lastfm::Track }

      def is_created_with(hash_values)
        subject.should_receive(:create).with(hash_including(hash_values))
      end

      it { is_created_with(event_timestamp: track['date']['uts']) }
      it { is_created_with(played_datetime: DateTime.parse(track['date']['content'])) }
      it { is_created_with(name: track['name']) }
      it { is_created_with(artist_name: track['artist']['content']) }
      it { is_created_with(album_name: track['album']['content']) }
      it { is_created_with(url: track['url']) }

      after { Trawler::Fetchers::LastfmParser.parse( [track] ) }
    end

    describe "the track's thumbnails" do
      subject { parsed_track.thumbnails }

      let(:image_url) { lambda { |i| "http://last.fm/images/image#{i}.png"  } }
      let(:number_of_images) { (Random.rand * 10).to_i }
      let(:images) { (1..number_of_images).map { |i| { 'size' => "image#{i}", 'content' => image_url.call(i) } } }

      let(:track_with_thumbnails) { track.merge('image' => images) }
      let(:parsed_track) { Trawler::Fetchers::LastfmParser.parse( [track_with_thumbnails] ).first }

      its(:size) { should == number_of_images }

      describe 'a thumbnail' do
        subject { parsed_track.thumbnails.last }
        its(:size) { should == "image#{number_of_images}" }
        its(:url)  { should == image_url.call(number_of_images) }
      end
    end
  end
end
