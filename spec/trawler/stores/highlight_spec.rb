require 'spec_helper'
require 'ostruct'

describe Trawler::Stores::Highlight do
  it { should have_fields(:text, :source, :source_id, :hidden, :date) }
  it { should belong_to(:book) }

  describe ".find_or_create" do
    context "with no existing highlights" do
      let!(:existing_highlight) {}

      it "creates a new highlight" do
        new_highlight = Trawler::Stores::Highlight.find_or_create "highlight text"
        expect(new_highlight).to be
        expect(new_highlight.text).to eq "highlight text"
        expect(Trawler::Stores::Highlight.count).to eq 1
      end

      it "calls the provided block" do
        new_highlight = Trawler::Stores::Highlight.find_or_create "highlight text" do |h|
          h.text = "My test text"
        end

        expect(new_highlight.text).to eq "My test text"
      end
    end

    context "with an existing highlight" do
      let!(:existing_highlight) do
        Trawler::Stores::Highlight.create(
          text: "highlight text",
          source: :readmill,
          source_id: "1",
          date: DateTime.new(2013, 10, 10))
      end

      it "returns the existing highlight" do
        highlight = Trawler::Stores::Highlight.find_or_create "highlight text"
        expect(highlight).to eq existing_highlight
      end
    end
  end
end
