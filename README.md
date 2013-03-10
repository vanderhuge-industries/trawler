# Trawler

Trawler crawls awl.

## Installation

Add this line to your application's Gemfile:

    gem 'trawler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trawler

## Testing

(NOTE: Start yerself a mongo all up in your favourite way.)

    bundle exec rspec


## Usage

### Last.fm

Grab yourself an API key here: (<http://www.last.fm/api/accounts>)

Fire up the secret source:

    Trawler::LastfmSource.collect(<your_api_key>, <your_lastfm_username>)

Check your mongos for a bunch of Tracks.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
