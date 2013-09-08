module Trawler
  module Sources
    module Readmill
      class Parser
        def highlights_from_json(json)
          json['items'].map {|i| i['highlight'] }.map do |item|
            OpenStruct.new({
              remote_id: item['id'].to_s,
              source: :readmill,
              text: item['content'],
              date: DateTime.parse(item['highlighted_at']),
              reading_id: item['reading']['id']
            })
          end
        end
      end
    end
  end
end

