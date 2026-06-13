module Wrails
  class Response
    attr_accessor :status, :body

    def initialize(status:, headers:, body:)
      @status = status
      @headers = headers
      @body = body
    end

    def headers
      @headers.dup
    end

    def set_header(key, value)
      @headers[key.to_s] = value
    end

    def to_ary
      [@status, @headers, [@body]]
    end
  end
end
