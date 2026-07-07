require_relative 'test_helper'

class TestController < Wrails::Controller
  def index
    response.body = 'Home Page'
  end
end

class WrailsTest < Minitest::Test
  def setup
    # Wrails::Routes.clear_routes!
    # Wrails::Config.views_path = 'test/files/views'
  end

  def assert_body(expected, response)
    assert_equal expected, response.body
  end

  def get(path)
    Wrails.app.call(Rack::MockRequest.env_for(path, method: 'GET'))
  end

  def test_get_request_to_existing_route
    Wrails.app.router.add_route(:get, '/test', 'test#index')
    assert_body 'Home Page', get('/test')
  end
end
