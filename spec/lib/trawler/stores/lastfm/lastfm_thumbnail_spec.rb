require 'spec_helper'

describe Trawler::Stores::Lastfm::Thumbnail do
  it { should have_fields(:size, :url) }
  it { should be_embedded_in(:track) }
end
