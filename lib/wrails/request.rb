require 'forwardable'

module Wrails
  class Request
    extend Forwardable

    def initialize(env)
      @rack_request = Rack::Request.new(env)
    end

    def_delegators :@rack_request,
                   :ip,
                   :host,
                   :user_agent,
                   :path,
                   :query_string

    # TODO: is diff behavior from rack needed here?
    def request_method
      @rack_request.request_method.downcase.to_sym
    end

    def params
      @rack_request.params.transform_keys(&:to_sym)
    end
  end
end
