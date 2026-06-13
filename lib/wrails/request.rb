module Wrails
  class Request
    def initialize(env)
      @rack_request = Rack::Request.new(env)
    end

    def request_method
      @rack_request.request_method.downcase.to_sym
    end

    def path
      @rack_request.path
    end

    def params
      @rack_request.params.transform_keys(&:to_sym)
    end
  end
end
