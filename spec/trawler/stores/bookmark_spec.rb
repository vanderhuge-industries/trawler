require 'spec_helper'

describe Trawler::Stores::Bookmark do
  it { should have_fields(:url, :title, :description, :tags, :time, :source, :source_id, :hidden) }

  describe ".find_or_create" do
    context "with no existing bookmarks" do
      let!(:existing_bookmark) {}

      it "creates a new bookmark" do
        new_bookmark = Trawler::Stores::Bookmark.find_or_create "bookmark url"
        expect(new_bookmark).to be
        expect(new_bookmark.url).to eq "bookmark url"
        expect(Trawler::Stores::Bookmark.count).to eq 1
      end

      it "calls the provided block" do
        new_bookmark = Trawler::Stores::Bookmark.find_or_create "bookmark url" do |b|
          b.description = "some description"
        end

        expect(new_bookmark.description).to eq "some description"
      end
    end

    context "with an existing bookmark" do
      let!(:existing_bookmark) do
        Trawler::Stores::Bookmark.create(
          url: "bookmark url",
          source: :pinboard,
          source_id: "1")
      end

      it "returns the existing bookmark" do
        bookmark = Trawler::Stores::Bookmark.find_or_create "bookmark url"
        expect(bookmark).to eq existing_bookmark
      end
    end
  end
end
