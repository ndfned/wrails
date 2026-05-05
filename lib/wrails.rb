require 'rack'
require 'puma'
require_relative 'wrails/routes'

module Wrails
  def self.handle_request(method, path)
    raise 'unsupported' unless method == 'get'

    handler = Wrails::Routes.routes[path]
    raise 'no handler found' unless handler

    handler.call
  end

  def self.call(env)
    [
      200,
      { 'Content-Type' => 'text/plain' },
      ['Hello from my framework']
    ]
  end

  def self.run!(port: 4567)
    server = Puma::Server.new(self)
    server.add_tcp_listener '127.0.0.1', port

    puts "Listening on http://localhost:#{port}"
    server.run
    sleep
  end
end
