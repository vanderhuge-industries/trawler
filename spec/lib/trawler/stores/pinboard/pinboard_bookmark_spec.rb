require 'spec_helper'

describe Trawler::Stores::Pinboard::Bookmark do
  it { should have_fields(:url, :description, :extended_description, :tags) }
  it { should have_field(:time) }
end
