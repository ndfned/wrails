require 'erb'

module Wrails
  class Controller
    attr_reader :request, :response

    def self.controller_name
      name.sub(/Controller$/, '').downcase
    end

    def initialize(request)
      @request = request
      @response = Response.new(
        status: 200,
        body: nil,
        headers: { 'Content-Type' => 'text/html' }
      )
    end

    def dispatch(action)
      send(action)

      render(erb(self.class.controller_name, action))
    end

    def render(text)
      @response.body = text
      @response
    end

    private

    def erb(controller_name, template_name, locals: {})
      template_name = "#{template_name}.erb"

      path = if Config.views_path
               File.join(Config.views_path, controller_name, template_name)
             else
               "views/#{controller_name}/#{template_name}"
             end

      template = File.read(path)
      ERB.new(template, trim_mode: '-').result_with_hash(locals)
    end
  end
end
