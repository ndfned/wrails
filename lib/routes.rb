module Routes
  @routes = {}

  class << self
    attr_reader :routes
  end

  def get(path, &block)
    Routes.routes[path] = block
  end
end

module Kernel
  include Routes
end
