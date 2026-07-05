module Wrails
  class App
    attr_reader :router

    def initialize
      @router = Router2.new
    end

    def call(env)
      router.dispatch(Request.new(env))
    end
  end
end
