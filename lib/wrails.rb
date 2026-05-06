require 'rack'
require 'puma'
require_relative 'wrails/routes'

module Wrails
  def self.handle_request(method, path)
    raise 'unsupported' unless method == 'get'

    handler = Wrails::Routes.routes[path]
    return unless handler

    handler.call
  end

  def self.call(env)
    result = handle_request(env['REQUEST_METHOD'].downcase, env['PATH_INFO'])

    if result.nil?
      [404, { 'Content-Type' => 'text/html' }, ['<h1>Not Found</h1>']]
    else
      [200, { 'Content-Type' => 'text/html' }, [result]]
    end
  end

  def self.run!(port: 4567)
    server = Puma::Server.new(self)
    server.add_tcp_listener '127.0.0.1', port

    puts "Listening on http://localhost:#{port}"
    server.run
    sleep
  end
end
