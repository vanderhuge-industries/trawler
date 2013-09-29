require 'spec_helper'

describe Trawler::Stores::Bookmark do
  it { should have_fields(:url, :title, :description, :tags, :time, :source, :source_id, :hidden) }
end
