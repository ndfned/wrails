require 'rack'

require 'erb'
require_relative 'wrails/routes'
require_relative 'wrails/config'

module Wrails
  class Request
    def initialize(env)
      @rack_request = Rack::Request.new(env)
    end

    def request_method
      @rack_request.request_method.downcase.to_sym
    end

    def path
      @rack_request.path
    end

    def params
      @rack_request.params.transform_keys(&:to_sym)
    end
  end

  class Response
    attr_accessor :status, :body

    def initialize(status:, headers:, body:)
      @status = status
      @headers = headers
      @body = body
    end

    def headers
      @headers.dup
    end

    def set_header(key, value)
      @headers[key.to_s] = value
    end

    def to_ary
      [@status, @headers, [@body]]
    end
  end

  class RouteContext
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def redirect(to)
      @response.status = 302
      @response.set_header('Location', to)

      nil
    end

    def content_type(type)
      raw_type = if type == :json
                   'application/json'
                 else
                   "unknown content_type: #{type}"
                 end

      @response.set_header('Content-Type', raw_type)

      nil
    end

    def headers(key, value)
      @response.set_header(key, value)

      nil
    end

    def erb(template_name, locals: {})
      template_name = "#{template_name}.erb"

      path = if Config.views_path
               File.join(Config.views_path, template_name)
             else
               "views/#{template_name}"
             end

      template = File.read(path)
      ERB.new(template, trim_mode: '-').result_with_hash(locals)
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

  def self.handle_request(request)
    raise 'unsupported' unless %i[get post put patch delete].include?(request.request_method)

    route = find_route(request.path, request.request_method)

    response = Response.new(
      status: 200,
      body: nil,
      headers: { 'Content-Type' => 'text/html' }
    )

    if route.nil?
      response.status = 404
      response.body = '<h1>Not Found</h1>'
      return response
    end

    context = RouteContext.new(response)
    params = if request.params.nil?
               route[:params]
             else
               # TODO: need to handle merge overwrite?
               route[:params].merge(request.params)
             end
    body = context.instance_exec(params, &route[:handler])
    if body.is_a?(String) || body.nil?
      response.body = body
    else
      raise 'invalid body value'
    end

    response
  end

  def self.call(env)
    handle_request(Request.new(env))
  end

  def self.run!(port: 4567)
    begin
      require 'puma'
    rescue LoadError
      raise LoadError, "Wrails requires Puma to run the server. Add `gem 'puma'` to your Gemfile."
    end

    server = Puma::Server.new(self)
    server.add_tcp_listener '127.0.0.1', port

    puts "Listening on http://localhost:#{port}"
    server.run
    sleep
  end
end
