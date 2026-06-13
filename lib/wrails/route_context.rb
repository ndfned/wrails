module Wrails
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
end
