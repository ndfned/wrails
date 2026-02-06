module Wrails
  module Routes
    @routes = {}

    class << self
      attr_reader :routes

      def get(path, &block)
        @routes[path] = block
      end
    end
  end
end
