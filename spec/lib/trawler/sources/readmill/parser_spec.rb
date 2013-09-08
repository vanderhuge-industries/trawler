require 'spec_helper'
require 'ostruct'

describe Trawler::Sources::Readmill::Parser do
  describe '#highlights_from_json' do
    result = nil

    let(:highlights_json) do
      {
        "pagination" => {
          "next" => "https://api.readmill.com/v2/users/2292/highlights?client_id=7c5a0fbcd6948a9cdf8e9156ed31c5a0&cou"
        },
        "items" => [
          {
            "highlight"=>
            {
              "id"=>575439,
              "position"=>0.0858322,
              "content"=> "The tractability of Lisp for metaprogramming purposes is the direct result",
              "highlighted_at" => "2013-08-29T13:44:52Z",
              "permalink" => "9ohx4w",
              "permalink_url" => "https://readmill.com/grassdog/reads/much-ado-about-naught/highlights/9ohx4w",
              "user" => {},
              "locators" => {},
              "comments_count" => 0,
              "likes_count" => 0,
              "reading" => { "id" => 278977}
            }
          },
          {
            "highlight"=>
            {
              "id"=>575399,
              "position" => 0.88073,
              "content" => "Conclusion Every now and then we run across a need",
              "highlighted_at" => "2013-08-29T13:13:10Z",
              "permalink" => "hvpgzq",
              "permalink_url" => "https://readmill.com/grassdog/reads/confident-ruby/highlights/hvpgzq",
              "user" => {},
              "locators" => {},
              "comments_count" => 0,
              "likes_count" => 0,
              "reading" => { "id" => 273024 }
            }
          }
        ],
        "status" => 200
      }
    end

    let(:parser) { Trawler::Sources::Readmill::Parser.new }

    before(:each) do
      result = parser.highlights_from_json(highlights_json)
    end

    it "returns an object for each highlight in the json" do
      expect(result.length).to eq(2)
    end

    it "set the attibutes of interest in the returned objects" do
      highlight = result.first
      expect(highlight.remote_id).to eq "575439"
      expect(highlight.source).to eq :readmill
      expect(highlight.text).to eq "The tractability of Lisp for metaprogramming purposes is the direct result"
      expect(highlight.date).to eq DateTime.new(2013, 8, 29, 13, 44, 52)
      expect(highlight.reading_id).to eq 278977
    end
  end
end


# Example highlights call
#   r = HTTParty.get("https://api.readmill.com/v2/users/2292/highlights?client_id=7c5a0fbcd6948a9cdf8e9156ed31c5a0&count=100")

# Example readings call
#r = HTTParty.get("https://api.readmill.com/v2/readings/224102?client_id=7c5a0fbcd6948a9cdf8e9156ed31c5a0")
