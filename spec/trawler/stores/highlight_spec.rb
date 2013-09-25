require 'spec_helper'

describe Trawler::Stores::Highlight do
  it { should have_field(:text) }
  it { should have_field(:source) }
  it { should belong_to(:book) }
end
