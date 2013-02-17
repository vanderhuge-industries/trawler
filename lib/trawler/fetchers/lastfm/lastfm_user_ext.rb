require 'lastfm'

# Monkey-patch ahoy!
#
# The default get_recent_tracks method on Lastfm.user doesn't include the
# meta information like:
#
#    "page"=>"1",
#    "perPage"=>"10",
#    "totalPages"=>"3",
#    "total"=>"23"
#
# We want the totalPages so that we can determine if we need to do *multiple
# fetches* to get all of the recent listens.
#
# This replacement method is the same as the one it overrides, but rather than returning
# the nested ['recenttracks']['track'] it returns the whole ['recenttracks']

class Lastfm
  module MethodCategory
    class User < Base
      regular_method :get_recent_tracks, [:user], [[:limit, nil], [:page, nil], [:to, nil], [:from, nil]] do |response|
        response.xml['recenttracks']
      end
    end
  end
end
