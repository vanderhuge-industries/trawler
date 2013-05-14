require 'spec_helper'

describe Trawler::Stores::Readmill::Highlight do
  it { should have_field(:text) }
  it { should be_embedded_in(:book) }
end
