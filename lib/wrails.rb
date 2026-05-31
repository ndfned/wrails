require 'rack'
require 'puma'
require_relative 'wrails/routes'
require_relative 'wrails/config'

module Wrails
  class RouteContext
    def erb(template_name)
      template_name = "#{template_name}.erb"

      path = if Config.views_path
               File.join(Config.views_path, template_name)
             else
               "views/#{template_name}"
             end

      File.read(path)
    end
  end

  def self.route_match?(path1, path2)
    segments1 = path1.split('/')
    segments2 = path2.split('/')

    return false unless segments1.size == segments2.size

    segments1.zip(segments2).all? do |segment1, segment2|
      segment1.start_with?(':') || segment1 == segment2
    end
  end

  def self.parse_path_params(path_pattern, path)
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

  def self.find_route(path, method)
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

  def self.handle_request(method:, path:, query_params: nil)
    raise 'unsupported' unless %w[get post put patch delete].include?(method)

    route = find_route(path, method.to_sym)
    if route.nil?
      return [404, { 'Content-Type' => 'text/html' }, ['<h1>Not Found</h1>']]
    end

    context = RouteContext.new

    params = if query_params.nil?
               route[:params]
             else
               # TODO: need to handle merge overwrite?
               route[:params].merge(query_params)
             end

    result = context.instance_exec(params, &route[:handler])
    raise 'bad result' unless result.is_a?(String) || result.nil?

    [200, { 'Content-Type' => 'text/html' }, [result]]
  end

  def self.call(env)
    # TODO: what about nested params?
    query_params = Rack::Utils.parse_query(env['QUERY_STRING'])
    query_params.transform_keys!(&:to_sym)

    method = env['REQUEST_METHOD'].downcase
    path = env['PATH_INFO']

    handle_request(method:, path:, query_params:)
  end

  def self.run!(port: 4567)
    server = Puma::Server.new(self)
    server.add_tcp_listener '127.0.0.1', port

    puts "Listening on http://localhost:#{port}"
    server.run
    sleep
  end
end
