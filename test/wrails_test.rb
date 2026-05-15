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

    result = Wrails.handle_request(method: 'get', path: '/test')
    assert_equal '<h1>Example</h1>', result
  end

  def test_get_request_to_another_existing_route
    Wrails::Routes.get '/other' do
      '<h1>Other</h1>'
    end

    result = Wrails.handle_request(method: 'get', path: '/other')
    assert_equal '<h1>Other</h1>', result
  end

  def test_get_request_to_nonexisting_route
    result = Wrails.handle_request(method: 'get', path: '/unexisiting')
    assert_nil result
  end

  def test_get_request_that_renders_template
    Wrails::Routes.get '/template1' do
      erb :template1
    end

    result = Wrails.handle_request(method: 'get', path: '/template1')
    assert_equal '<h1>Template1</h1>', result
  end

  def test_post_request_to_existing_route
    Wrails::Routes.post '/test' do
      # create smth
    end

    result = Wrails.handle_request(method: 'post', path: '/test')
    assert_nil result
  end

  def test_put_request_to_existing_route
    Wrails::Routes.put '/test' do
      # replace smth
    end

    result = Wrails.handle_request(method: 'put', path: '/test')
    assert_nil result
  end

  def test_patch_request_to_existing_route
    Wrails::Routes.patch '/patch' do
      # modify smth
    end

    result = Wrails.handle_request(method: 'patch', path: '/test')
    assert_nil result
  end

  def test_delete_request_to_existing_route
    Wrails::Routes.delete '/test' do
      # delete smth
    end

    result = Wrails.handle_request(method: 'delete', path: '/test')
    assert_nil result
  end

  def test_get_request_with_dynamic_parameter
    Wrails::Routes.get '/test/:name' do |params|
      "Hello #{params[:name]}!"
    end

    result = Wrails.handle_request(method: 'get', path: '/test/denis')
    assert_equal 'Hello denis!', result
  end

  def test_multiple_routes_with_different_methods_to_same_path
    Wrails::Routes.get '/test' do
      '<h1>Example</h1>'
    end

    Wrails::Routes.post '/test' do
      # create smth
    end

    get_result = Wrails.handle_request(method: 'get', path: '/test')
    post_result = Wrails.handle_request(method: 'post', path: '/test')

    assert_equal '<h1>Example</h1>', get_result
    assert_nil post_result
  end

  def test_get_request_with_query_parameters
    Wrails::Routes.get '/test' do |params|
      "Hello #{params[:name]} #{params[:lastname]}!"
    end

    result = Wrails.handle_request(
      method: 'get',
      path: '/test',
      query_params: { name: 'John', lastname: 'Doe' }
    )
    assert_equal 'Hello John Doe!', result
  end
end
