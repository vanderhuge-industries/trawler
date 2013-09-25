require 'spec_helper'

describe Trawler::Stores::Bookmark do
  it { should have_fields(:url, :title, :description, :tags) }
  it { should have_field(:time) }
end