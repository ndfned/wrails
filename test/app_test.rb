require_relative 'test_helper'

class AppTest < Minitest::Test
  def test_routes
    get '/test' do
      '<h1>Example</h1>'
    end

    get '/other' do
      '<h1>Not Found</h1>'
    end

    result = handle_request('get', '/test')
    assert_equal '<h1>Example</h1>', result

    result = handle_request('get', '/other')
    assert_equal '<h1>Not Found</h1>', result
  end
end
