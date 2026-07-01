module Wrails
  class App
    def call(env)
      handle_request(Request.new(env))
    end

    def handle_request(request)
      raise 'unsupported' unless %i[get post put patch delete].include?(request.request_method)

      route = router.find_route(request.request_method, request.path)
      return no_route_response if route.nil?

      response.body = exec_action(route)
      raise 'invalid body value' unless response.body.is_a?(String) || response.body.nil?

      response
    end

    def draw_routes(&block)
      router.draw(&block)
    end

    def router
      @router ||= Wrails::Router2.new
    end

    private

    def response
      @response ||= Wrails::Response.new(
        status: 200,
        body: nil,
        headers: { 'Content-Type' => 'text/html' }
      )
    end

    def no_route_response
      response.status = 404
      response.body = '<h1>Not Found</h1>'

      response
    end

    def exec_action(route)
      controller_name, action = route[:target].split('#')
      controller_full_name = "#{controller_name.capitalize}Controller"
      controller_class = Object.const_get(controller_full_name)
      controller = controller_class.new

      allowed_actions = %w[index show]
      if allowed_actions.include?(action)
        controller.send(action)
      end
    end
  end
end
