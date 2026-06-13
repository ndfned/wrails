module Wrails
  module Router
    class << self
      def find_route(path, method)
        Wrails::Routes.routes[method].each do |route_pattern, handler|
          if route_match?(route_pattern, path)
            return {
              path: path,
              handler: handler,
              params: parse_path_params(route_pattern, path)
            }
          end
        end

        nil
      end

      private

      def route_match?(path1, path2)
        segments1 = path1.split('/')
        segments2 = path2.split('/')

        return false unless segments1.size == segments2.size

        segments1.zip(segments2).all? do |segment1, segment2|
          segment1.start_with?(':') || segment1 == segment2
        end
      end

      def parse_path_params(path_pattern, path)
        path_patterns = path_pattern.split('/')
        path_segments = path.split('/')

        params = {}
        path_patterns.each_with_index do |path_pattern, index|
          next unless path_pattern.start_with?(':')

          param_name = path_pattern[1..].to_sym
          param_value = path_segments[index]
          params[param_name] = param_value
        end

        params
      end
    end
  end
end
