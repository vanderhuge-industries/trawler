require 'spec_helper'
require 'ostruct'

describe Trawler::Sources::Readmill::Parser do
  let(:parser) { Trawler::Sources::Readmill::Parser.new }

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
              "reading" => { "id" => 278977 }
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

    before(:each) do
      result = parser.highlights_from_json(highlights_json)
    end

    it "returns an object for each highlight in the json" do
      expect(result.length).to eq(2)
    end

    it "set the attibutes of interest in the returned objects" do
      highlight = result.first
      expect(highlight.source_id).to eq "575439"
      expect(highlight.source).to eq :readmill
      expect(highlight.text).to eq "The tractability of Lisp for metaprogramming purposes is the direct result"
      expect(highlight.date).to eq DateTime.new(2013, 8, 29, 13, 44, 52)
      expect(highlight.reading_id).to eq 278977
    end
  end
  describe '#book_from_reading_json' do
    result = nil

    let(:reading_json) do
      {"reading"=>
        {"id"=>224102,
         "state"=>"finished",
         "private"=>false,
         "recommended"=>true,
         "closing_remark"=>nil,
         "created_at"=>"2013-06-21T08:41:20Z",
         "started_at"=>"2013-06-21T08:41:20Z",
         "touched_at"=>"2013-06-22T16:25:08Z",
         "ended_at"=>"2013-06-22T16:25:08Z",
         "duration"=>0,
         "progress"=>1.0,
         "estimated_time_left"=>nil,
         "average_period_time"=>0,
         "book"=>
          {"id"=>93053,
           "title"=>"Bad Blood",
           "author"=>"Will Storr",
           "permalink"=>"bad-blood",
           "permalink_url"=>"https://readmill.com/books/bad-blood",
           "cover_url"=>
            "https://d26cmntuippvfl.cloudfront.net?action=shrink-w&format=png&origin=https%253A%252F%252Freadmill-assets.s3.amazonaws.com%252Fcovers%252F2ff6df6afed193b67df4c6f4fe2692f1813823a9-original.png&width=120",
           "cover_metadata"=>{"original_width"=>469, "original_height"=>751}},
         "user"=>
          {"id"=>2292,
           "username"=>"grassdog",
           "firstname"=>"Ray",
           "fullname"=>"Ray Grasso",
           "avatar_url"=>
            "https://d26cmntuippvfl.cloudfront.net?action=crop&format=png&height=50&origin=https%253A%252F%252Freadmill-assets.s3.amazonaws.com%252Favatars%252F2bc2605b27da88eaee5547678c12721ab8a4dc8c-original.png&width=50",
           "followers_count"=>3,
           "followings_count"=>19,
           "permalink_url"=>"https://readmill.com/grassdog"},
         "permalink_url"=>"https://readmill.com/grassdog/reads/bad-blood",
         "comments_count"=>0,
         "highlights_count"=>3,
         "position"=>0.960565,
         "position_updated_at"=>"2013-06-22T16:25:00Z",
         "entities"=>{"hashtags"=>[]}},
       "status"=>200}
    end

    it "set the attibutes of interest in the returned objects" do
      book = parser.book_from_reading_json(reading_json)

      expect(book.source_id).to eq "93053"
      expect(book.source).to eq :readmill
      expect(book.title).to eq "Bad Blood"
      expect(book.author).to eq "Will Storr"
      expect(book.cover_url).to eq "https://d26cmntuippvfl.cloudfront.net?action=shrink-w&format=png&origin=https%253A%252F%252Freadmill-assets.s3.amazonaws.com%252Fcovers%252F2ff6df6afed193b67df4c6f4fe2692f1813823a9-original.png&width=120"
    end
  end
end


# Example highlights call
#   r = HTTParty.get("https://api.readmill.com/v2/users/2292/highlights?client_id=7c5a0fbcd6948a9cdf8e9156ed31c5a0&count=100")

# Example readings call
#r = HTTParty.get("https://api.readmill.com/v2/readings/224102?client_id=7c5a0fbcd6948a9cdf8e9156ed31c5a0")
