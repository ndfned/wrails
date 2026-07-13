module Wrails
  class RoutesBuilder
    def initialize(router)
      @router = router
    end

    def get(path, to:)
      @router.add_route(:get, path, to)
    end

    def post(path, to:)
      @router.add_route(:post, path, to)
    end
  end
end
