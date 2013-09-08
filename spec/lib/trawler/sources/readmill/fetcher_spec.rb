require 'spec_helper'
require 'ostruct'

describe Trawler::Sources::Readmill::Fetcher do

  let(:client_id) { 'client-id' }
  let(:parser) { double('parser', call: nil) }
  let(:fetcher) { Trawler::Sources::Readmill::Fetcher.new(client_id, parser) }

  describe '#highlights_for_user' do
    let(:response) { OpenStruct.new(code: 200, parsed_response: {}) }

    it 'fetches highlights from Readmill for the user' do
      HTTParty.stub(:get).and_return(OpenStruct.new(code: 200, body: ''))

      fetcher.highlights_for_user('user-id')

      expect(HTTParty).to have_received(:get).with('https://api.readmill.com/v2/users/user-id/highlights?client_id=client-id&count=100')
    end

    it 'passes the parsed response to the highlight parser' do
      HTTParty.stub(:get).and_return(OpenStruct.new(code: 200, parsed_response: {}))

      fetcher.highlights_for_user('user-id')

      expect(parser).to have_received(:call).with({})
    end

    it 'raises if there is an error fetching' do
      HTTParty.stub(:get).and_return(OpenStruct.new(code: 500, parsed_response: {}))

      expect { fetcher.highlights_for_user('user-id')}.to raise_error
    end
  end
end
