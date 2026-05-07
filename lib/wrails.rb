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

  def self.handle_request(method, path)
    raise 'unsupported' unless %w[get post].include?(method)

    handler = Wrails::Routes.routes[path][method.to_sym]
    return unless handler

    context = RouteContext.new
    context.instance_eval(&handler)
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
