require 'rack'

require_relative 'wrails/app'
require_relative 'wrails/config'
require_relative 'wrails/controller'
require_relative 'wrails/request'
require_relative 'wrails/response'
require_relative 'wrails/router'
require_relative 'wrails/routes_builder'

module Wrails
  def self.app
    @app ||= Wrails::App.new
  end

  def self.run!(port: 4567)
    begin
      require 'puma'
    rescue LoadError
      raise LoadError, "Wrails requires Puma to run the server. Add `gem 'puma'` to your Gemfile."
    end

    server = Puma::Server.new(app)
    server.add_tcp_listener '127.0.0.1', port

    puts "Listening on http://localhost:#{port}"
    server.run
    sleep
  end
end
