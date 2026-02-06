require_relative 'wrails/routes'

module Wrails
  def self.handle_request(method, path)
    raise 'unsupported' unless method == 'get'

    handler = Wrails::Routes.routes[path]
    raise 'no handler found' unless handler

    handler.call
  end
end
