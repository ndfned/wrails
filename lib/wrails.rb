require 'rack'

require_relative 'wrails/config'
require_relative 'wrails/request'
require_relative 'wrails/response'
require_relative 'wrails/routes'
require_relative 'wrails/router'
require_relative 'wrails/route_context'

module Wrails
  def self.handle_request(request)
    raise 'unsupported' unless %i[get post put patch delete].include?(request.request_method)

    route = Wrails::Router.find_route(request.path, request.request_method)

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

    context = RouteContext.new(request, response)
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
