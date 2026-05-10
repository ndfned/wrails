module Wrails
  module Routes
    @routes = { get: {}, post: {} }

    class << self
      attr_reader :routes

      def clear_routes!
        @routes = { get: {}, post: {} }
      end

      def get(path, &block)
        @routes[:get][path] = block
      end

      def post(path, &block)
        @routes[:post][path] = block
      end
    end
  end
end
