module Wrails
  module Routes
    @routes = {}

    class << self
      attr_reader :routes

      def get(path, &block)
        @routes[path] ||= {}
        @routes[path][:get] = block
      end

      def post(path, &block)
        @routes[path] ||= {}
        @routes[path][:post] = block
      end
    end
  end
end
