require 'routes'

def handle_request(method, path)
  raise 'unsupported' unless method == 'get'

  handler = Routes.routes[path]
  raise 'no handler found' unless handler

  handler.call
end
