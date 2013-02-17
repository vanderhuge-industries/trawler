require 'spec_helper'

describe Trawler::Fetchers::LastfmFetcher do

  describe 'fetching recent tracks' do
    let(:username) { 'arnold' }

    let(:fake_lastfm_user)  { mock(:lastfmuser) }
    let(:fake_lastfm)       { mock(:lastfm, :user => fake_lastfm_user) }
    let(:fake_store)        { mock(:lastfmstore, :latest_timestamp => Time.now.to_i) }
    let(:fake_response)     { { 'totalPages' => '', 'track' => [] } }

    let(:fetcher) { Trawler::Fetchers::LastfmFetcher.new(fake_store, fake_lastfm) }

    it 'fetches recent tracks for the supplied user' do
      fake_lastfm_user.should_receive(:get_recent_tracks).with(username, anything).and_return(fake_response)
      fetcher.fetch(username)
    end

    context 'when there has not been a previous fetch' do
      before { fake_store.stub(:latest_timestamp).and_return(nil) }

      it 'loads the last 200 tracks that have been scrobbled' do
        fake_lastfm_user.should_receive(:get_recent_tracks).with(anything, hash_including(:limit => 200)).and_return(fake_response)
        fetcher.fetch(username)
      end
    end

    context 'when there has been a previous fetch' do
      let(:last_fetch_timestamp) { 12345678 }
      before { fake_store.stub(:latest_timestamp).and_return(last_fetch_timestamp) }

      it 'only loads tracks scrobbled after the last fetch' do
        fake_lastfm_user.should_receive(:get_recent_tracks).with(anything, hash_including(:from => last_fetch_timestamp)).and_return(fake_response)
        fetcher.fetch(username)
      end
    end

    context 'when there is more than one page of recent tracks' do
      let(:fake_tracks) { [:a, :b, :c ] }

      before do
        fake_lastfm_user.stub(:get_recent_tracks).and_return('totalPages' => '3', 'track' => fake_tracks)
      end

      it 'repeats the fetch for each page' do
        fake_lastfm_user.should_receive(:get_recent_tracks).with(anything, anything)
        fake_lastfm_user.should_receive(:get_recent_tracks).with(anything, hash_including(:page => 2))
        fake_lastfm_user.should_receive(:get_recent_tracks).with(anything, hash_including(:page => 3))

        fetcher.fetch(username)
      end

      it 'concatenates the results' do
        result_tracks = fetcher.fetch(username)
        result_tracks.should == fake_tracks * 3
      end
    end
  end
end
