require 'spec_helper'

describe Trawler::Stores::Book do
  it { should have_fields(:title, :author) }
  it { should have_field(:last_update) }

  describe 'highlights' do
    it { should have_many(:highlights) }
  end
end
