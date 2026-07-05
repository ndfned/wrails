module Wrails
  class Controller
    attr_reader :request, :response

    def initialize(request)
      @request = request
      @response = Response.new(
        status: 200,
        body: nil,
        headers: { 'Content-Type' => 'text/html' }
      )
    end

    def index
      @response
    end
  end
end
