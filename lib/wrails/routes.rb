module Wrails
  module Routes
    @routes = { get: {}, post: {}, put: {}, patch: {}, delete: {} }

    class << self
      attr_reader :routes

      def clear_routes!
        @routes = { get: {}, post: {}, put: {}, patch: {}, delete: {} }
      end

      def get(path, &block)
        @routes[:get][path] = block
      end

      def post(path, &block)
        @routes[:post][path] = block
      end

      def put(path, &block)
        @routes[:put][path] = block
      end

      def patch(path, &block)
        @routes[:patch][path] = block
      end

      def delete(path, &block)
        @routes[:delete][path] = block
      end
    end
  end
end
