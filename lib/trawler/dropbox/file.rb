require 'dropbox_sdk'

module Trawler
  module Dropbox
    class FileReader
      def initializer(access_token)
        @access_token = access_token
      end

      def read_file(path)
        client = DropboxClient.new(@access_token)
        contents, metadata = client.get_file_and_metadata(path)
      end
    end
  end
end
