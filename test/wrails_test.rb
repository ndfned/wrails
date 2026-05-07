require_relative 'test_helper'

class WrailsTest < Minitest::Test
  def setup
    Wrails::Routes.routes.clear
  end

  def test_routes
    Wrails::Config.views_path = 'test/files/views'

    Wrails::Routes.get '/test' do
      '<h1>Example</h1>'
    end

    Wrails::Routes.get '/other' do
      '<h1>Not Found</h1>'
    end

    Wrails::Routes.get '/template1' do
      erb :template1
    end

    result = Wrails.handle_request('get', '/test')
    assert_equal '<h1>Example</h1>', result

    result = Wrails.handle_request('get', '/other')
    assert_equal '<h1>Not Found</h1>', result

    result = Wrails.handle_request('get', '/template1')
    assert_equal '<h1>Template1</h1>', result
  end
end
