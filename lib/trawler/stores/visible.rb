module Trawler
  module Stores
    module Visible
      def self.included(base)
        base.field :hidden, type: Boolean

        def base.visible
          self.in(hidden: [false, nil])
        end
      end
    end
  end
end
