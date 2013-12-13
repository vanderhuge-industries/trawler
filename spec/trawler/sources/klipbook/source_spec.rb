require "spec_helper"

describe Trawler::Sources::Klipbook::Source do

  let(:json) {
    [
      {
        "asin" => "B004H1U314",
        "author" => "James G. Skakoon, W.J. King",
        "title" => "Unwritten Laws of Engineering: Revised and Updated Edition",
        "last_update" => "2013-02-09T00:00:00+00:00",
        "clippings" => [
          {
            "annotation_id" => "aYOI0VCGG25ZA",
            "text" => "the spirit and effectiveness with which you tackle your first humble tasks will very likely be carefully watched and may affect your entire career.",
            "location" => 98,
            "type" => "highlight",
            "page" => nil
          },
          {
            "annotation_id" => "a2KIZ529DNUAJ",
            "text" => "initiative, which is expressed in energy to start things and aggressiveness to keep them moving briskly, resourcefulness or ingenuity, i.e., the faculty for finding ways to accomplish the desired result, and persistence (tenacity), which is the disposition to persevere in spite of difficulties, discouragement, or indifference.",
            "location" => 110,
            "type" => "highlight",
            "page" => nil
          },
          {
            "annotation_id" => "a2KIZ529DNUAJ",
            "text" => "the three characteristcs of getting things done",
            "location" => 110,
            "type" => "note",
            "page" => nil
          }
        ]
      }
    ]
  }

  let(:source) { Trawler::Sources::Klipbook::Source.new }

  describe "#collect" do

    before(:each) do
      source.import(json)
    end

    it "only saves highlights and not notes" do
      expect(Trawler::Stores::Highlight.count).to eq 2
    end

    it "saves books" do
      expect(Trawler::Stores::Book.count).to eq 1
    end
  end
end

