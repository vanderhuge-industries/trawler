require 'spec_helper'

describe Trawler::Stores::Readmill::Highlight do
  it { should have_field(:text) }
  it { should belong_to(:book) }
end
