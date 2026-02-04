module MyLib
  @routes = {}

  def get(path, &block)
    MyLib.routes[path] = block
  end

  def self.routes
    @routes
  end
end

module Kernel
  include MyLib
end

def handle_request(method, path)
  raise 'unsupported' unless method == 'get'

  handler = MyLib.routes[path]
  raise 'no handler found' unless handler

  handler.call
end
