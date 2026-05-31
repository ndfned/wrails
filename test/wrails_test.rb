require_relative 'test_helper'

class WrailsTest < Minitest::Test
  def setup
    Wrails::Routes.clear_routes!
    Wrails::Config.views_path = 'test/files/views'
  end

  def body_from(result)
    result.is_a?(Array) ? result[2][0] : result
  end

  def assert_body(expected, result)
    assert_equal expected, body_from(result)
  end

  def assert_body_nil(result)
    assert_nil body_from(result)
  end

  def test_get_request_to_existing_route
    Wrails::Routes.get '/test' do
      '<h1>Example</h1>'
    end

    result = Wrails.handle_request(method: 'get', path: '/test')
    assert_body '<h1>Example</h1>', result
  end

  def test_get_request_to_another_existing_route
    Wrails::Routes.get '/other' do
      '<h1>Other</h1>'
    end

    result = Wrails.handle_request(method: 'get', path: '/other')
    assert_body '<h1>Other</h1>', result
  end

  def test_get_request_to_nonexisting_route
    result = Wrails.handle_request(method: 'get', path: '/unexisiting')
    assert_body '<h1>Not Found</h1>', result
  end

  def test_get_request_that_renders_template
    Wrails::Routes.get '/template1' do
      erb :template1
    end

    result = Wrails.handle_request(method: 'get', path: '/template1')

    assert_includes body_from(result), '<h1>Template1</h1>'
    assert_includes body_from(result), 'Hello guest'
  end

  def test_get_request_that_renders_template_with_param
    Wrails::Routes.get '/template1' do
      erb :template1, locals: { name: 'John' }
    end

    result = Wrails.handle_request(method: 'get', path: '/template1')

    assert_includes body_from(result), '<h1>Template1</h1>'
    assert_includes body_from(result), 'Hello John'
  end

  def test_post_request_to_existing_route
    Wrails::Routes.post '/test' do
      # create smth
    end

    result = Wrails.handle_request(method: 'post', path: '/test')
    assert_body_nil result
  end

  def test_put_request_to_existing_route
    Wrails::Routes.put '/test' do
      # replace smth
    end

    result = Wrails.handle_request(method: 'put', path: '/test')
    assert_body_nil result
  end

  def test_patch_request_to_existing_route
    Wrails::Routes.patch '/test' do
      # replace smth
    end

    result = Wrails.handle_request(method: 'patch', path: '/test')
    assert_body_nil result
  end

  def test_delete_request_to_existing_route
    Wrails::Routes.delete '/test' do
      # delete smth
    end

    result = Wrails.handle_request(method: 'delete', path: '/test')
    assert_body_nil result
  end

  def test_get_request_with_dynamic_parameter
    Wrails::Routes.get '/test/:name' do |params|
      "Hello #{params[:name]}!"
    end

    result = Wrails.handle_request(method: 'get', path: '/test/denis')
    assert_body 'Hello denis!', result
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

    assert_body '<h1>Example</h1>', get_result
    assert_body_nil post_result
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
    assert_body 'Hello John Doe!', result
  end

  def test_dynamic_route_overwrite_static_first
    Wrails::Routes.get '/test/new' do
      '<h1>New Page</h1>'
    end

    Wrails::Routes.get '/test/:name' do |params|
      "<h1>Hello #{params[:name]}!</h1>"
    end

    get_result1 = Wrails.handle_request(method: 'get', path: '/test/new')
    assert_body '<h1>New Page</h1>', get_result1

    get_result2 = Wrails.handle_request(method: 'get', path: '/test/denis')
    assert_body '<h1>Hello denis!</h1>', get_result2
  end

  def test_routes_overwrite_dynamic_first
    Wrails::Routes.get '/test/:name' do |params|
      "<h1>Hello #{params[:name]}!</h1>"
    end

    # this route is unreacheable but it is expected
    Wrails::Routes.get '/test/new' do
      '<h1>New Page</h1>'
    end

    get_result1 = Wrails.handle_request(method: 'get', path: '/test/new')
    assert_body '<h1>Hello new!</h1>', get_result1

    get_result2 = Wrails.handle_request(method: 'get', path: '/test/denis')
    assert_body '<h1>Hello denis!</h1>', get_result2
  end

  def test_routes_overwrite_two_statics
    Wrails::Routes.get '/test/new' do
      '<h1>New Page</h1>'
    end

    Wrails::Routes.get '/test/new' do
      '<h1>Test Page</h1>'
    end

    get_result = Wrails.handle_request(method: 'get', path: '/test/new')
    assert_body '<h1>Test Page</h1>', get_result
  end
end
