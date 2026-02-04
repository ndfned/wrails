require 'minitest/autorun'
require_relative 'app'

class AppTest < Minitest::Test
  def test_test_route
    result = handle_request('/test')
    assert_equal '<h1>Example</h1>', result
  end

  def test_unknown_route
    result = handle_request('/other')
    assert_equal '<h1>Not Found</h1>', result
  end
end
