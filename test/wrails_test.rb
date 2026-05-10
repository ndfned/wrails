require_relative 'test_helper'

class WrailsTest < Minitest::Test
  def setup
    Wrails::Routes.clear_routes!
    Wrails::Config.views_path = 'test/files/views'
  end

  def test_get_request_to_existing_route
    Wrails::Routes.get '/test' do
      '<h1>Example</h1>'
    end

    result = Wrails.handle_request('get', '/test')
    assert_equal '<h1>Example</h1>', result
  end

  def test_get_request_to_another_existing_route
    Wrails::Routes.get '/other' do
      '<h1>Other</h1>'
    end

    result = Wrails.handle_request('get', '/other')
    assert_equal '<h1>Other</h1>', result
  end

  def test_get_request_to_nonexisting_route
    result = Wrails.handle_request('get', '/unexisiting')
    assert_nil result
  end

  def test_get_request_that_renders_template
    Wrails::Routes.get '/template1' do
      erb :template1
    end

    result = Wrails.handle_request('get', '/template1')
    assert_equal '<h1>Template1</h1>', result
  end

  def test_post_request_to_existing_route
    Wrails::Routes.post '/test' do
      # create smth
    end

    result = Wrails.handle_request('post', '/test')
    assert_nil result
  end

  def test_get_request_with_dynamic_parameter
    Wrails::Routes.get '/test/:name' do |params|
      "Hello #{params[:name]}!"
    end

    result = Wrails.handle_request('get', '/test/denis')
    assert_equal 'Hello denis!', result
  end

  def test_multiple_routes_with_different_methods_to_same_path
    Wrails::Routes.get '/test' do
      '<h1>Example</h1>'
    end

    Wrails::Routes.post '/test' do
      # create smth
    end

    get_result = Wrails.handle_request('get', '/test')
    post_result = Wrails.handle_request('post', '/test')

    assert_equal '<h1>Example</h1>', get_result
    assert_nil post_result
  end
end
