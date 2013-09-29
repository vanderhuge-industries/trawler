require 'spec_helper'

describe Trawler::Stores::Book do
  it { should have_fields(:title, :author, :last_update, :source, :source_id, :cover_url, :hidden) }

  describe 'highlights' do
    it { should have_many(:highlights) }
  end
end
