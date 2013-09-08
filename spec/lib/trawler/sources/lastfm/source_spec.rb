require 'spec_helper'
require 'json'
require 'lastfm'

describe Trawler::Sources::Lastfm::Source do

  # Do we want to do an integration test here?
  # - Stub out Lastfm.new, return a stub with tracks in lastfm.user.get_recent_tracks
  # - Then just the source over those and see if we get what we want in the database?
  describe 'collecting tracks' do
    let(:lastfm_json) { File.read("#{File.dirname(__FILE__)}/../../../../canned_data/lastfm_tracks.json") }
    let(:lastfm_tracks) { JSON.parse(lastfm_json) }
    let(:lastfm_result) { { 'track' => lastfm_tracks, 'totalPages' => 1 } }
    before do
      fake_lastfm = double(:lastfm, :user => double(:lastfm_user, :get_recent_tracks => lastfm_result))
      Lastfm.stub(:new).and_return(fake_lastfm)
    end

    before { Trawler::Sources::Lastfm::Source.collect('lastfm_key', 'lastfm_username') }

    it 'fetches, parses and stores the Lastfm tracks' do
      Trawler::Stores::Lastfm::Track.count.should == 5
      Trawler::Stores::Lastfm::Track.all.map(&:artist_name).uniq.should == [ 'Autre Ne Veut' ]
    end
  end
end
