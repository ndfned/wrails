module Wrails
  module Config
    @config = {}

    class << self
      def views_path=(path)
        @config[:views_path] = path
      end

      def views_path
        @config[:views_path]
      end
    end
  end
end
