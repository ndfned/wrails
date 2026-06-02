require_relative 'test_helper'

class WrailsTest < Minitest::Test
  def setup
    Wrails::Routes.clear_routes!
    Wrails::Config.views_path = 'test/files/views'
  end

  def assert_body(expected, response)
    assert_equal expected, response.body
  end

  def assert_status(expected, response)
    assert_equal expected, response.status
  end

  def assert_body_nil(response)
    assert_nil response.body
  end

  def assert_redirect(response)
    assert_body_nil response
    assert_status 302, response
  end

  def assert_content_type(type)
    assert_status type, response.content_type
  end

  def assert_json(hash, response)
    assert_equal 'application/json', response.headers['Content-Type']
    assert_body hash.to_json, response
  end

  def test_get_request_to_existing_route
    Wrails::Routes.get '/test' do
      '<h1>Example</h1>'
    end

    response = Wrails.handle_request(method: 'get', path: '/test')
    assert_body '<h1>Example</h1>', response
  end

  def test_get_request_to_another_existing_route
    Wrails::Routes.get '/other' do
      '<h1>Other</h1>'
    end

    response = Wrails.handle_request(method: 'get', path: '/other')
    assert_body '<h1>Other</h1>', response
  end

  def test_get_request_to_nonexisting_route
    response = Wrails.handle_request(method: 'get', path: '/unexisiting')
    assert_body '<h1>Not Found</h1>', response
  end

  def test_get_request_that_renders_template
    Wrails::Routes.get '/template1' do
      erb :template1
    end

    response = Wrails.handle_request(method: 'get', path: '/template1')

    assert_includes response.body, '<h1>Template1</h1>'
    assert_includes response.body, 'Hello guest'
  end

  def test_get_request_that_renders_template_with_param
    Wrails::Routes.get '/template1' do
      erb :template1, locals: { name: 'John' }
    end

    response = Wrails.handle_request(method: 'get', path: '/template1')

    assert_includes response.body, '<h1>Template1</h1>'
    assert_includes response.body, 'Hello John'
  end

  def test_post_request_to_existing_route
    Wrails::Routes.post '/test' do
      # create smth
    end

    response = Wrails.handle_request(method: 'post', path: '/test')
    assert_body_nil response
  end

  def test_put_request_to_existing_route
    Wrails::Routes.put '/test' do
      # replace smth
    end

    response = Wrails.handle_request(method: 'put', path: '/test')
    assert_body_nil response
  end

  def test_patch_request_to_existing_route
    Wrails::Routes.patch '/test' do
      # replace smth
    end

    response = Wrails.handle_request(method: 'patch', path: '/test')
    assert_body_nil response
  end

  def test_delete_request_to_existing_route
    Wrails::Routes.delete '/test' do
      # delete smth
    end

    response = Wrails.handle_request(method: 'delete', path: '/test')
    assert_body_nil response
  end

  def test_get_request_with_dynamic_parameter
    Wrails::Routes.get '/test/:name' do |params|
      "Hello #{params[:name]}!"
    end

    response = Wrails.handle_request(method: 'get', path: '/test/denis')
    assert_body 'Hello denis!', response
  end

  def test_get_request_with_different_http_code
    Wrails::Routes.get '/not_found' do |params|
      if params[:name].nil?
        response.status = 404
        'Not found'
      else
        "Hello #{params[:name]}!"
      end
    end

    response = Wrails.handle_request(
      method: 'get',
      path: '/not_found'
    )
    assert_body 'Not found', response
    assert_status 404, response

    response = Wrails.handle_request(
      method: 'get',
      path: '/not_found',
      query_params: { name: 'John' }
    )

    assert_body 'Hello John!', response
    assert_status 200, response
  end

  def test_multiple_routes_with_different_methods_to_same_path
    Wrails::Routes.get '/test' do
      '<h1>Example</h1>'
    end

    Wrails::Routes.post '/test' do
      # create smth
    end

    get_response = Wrails.handle_request(method: 'get', path: '/test')
    post_response = Wrails.handle_request(method: 'post', path: '/test')

    assert_body '<h1>Example</h1>', get_response
    assert_body_nil post_response
  end

  def test_get_request_with_query_parameters
    Wrails::Routes.get '/test' do |params|
      "Hello #{params[:name]} #{params[:lastname]}!"
    end

    response = Wrails.handle_request(
      method: 'get',
      path: '/test',
      query_params: { name: 'John', lastname: 'Doe' }
    )
    assert_body 'Hello John Doe!', response
  end

  def test_dynamic_route_overwrite_static_first
    Wrails::Routes.get '/test/new' do
      '<h1>New Page</h1>'
    end

    Wrails::Routes.get '/test/:name' do |params|
      "<h1>Hello #{params[:name]}!</h1>"
    end

    get_response1 = Wrails.handle_request(method: 'get', path: '/test/new')
    assert_body '<h1>New Page</h1>', get_response1

    get_response2 = Wrails.handle_request(method: 'get', path: '/test/denis')
    assert_body '<h1>Hello denis!</h1>', get_response2
  end

  def test_routes_overwrite_dynamic_first
    Wrails::Routes.get '/test/:name' do |params|
      "<h1>Hello #{params[:name]}!</h1>"
    end

    # this route is unreacheable but it is expected
    Wrails::Routes.get '/test/new' do
      '<h1>New Page</h1>'
    end

    get_response1 = Wrails.handle_request(method: 'get', path: '/test/new')
    assert_body '<h1>Hello new!</h1>', get_response1

    get_response2 = Wrails.handle_request(method: 'get', path: '/test/denis')
    assert_body '<h1>Hello denis!</h1>', get_response2
  end

  def test_routes_overwrite_two_statics
    Wrails::Routes.get '/test/new' do
      '<h1>New Page</h1>'
    end

    Wrails::Routes.get '/test/new' do
      '<h1>Test Page</h1>'
    end

    response = Wrails.handle_request(method: 'get', path: '/test/new')
    assert_body '<h1>Test Page</h1>', response
  end

  def test_response_modification
    Wrails::Routes.get '/test' do
      response.status = 404
      'OK'
    end

    response = Wrails.handle_request(method: 'get', path: '/test')
    assert_body 'OK', response
    assert_status 404, response
  end

  def test_redirect
    Wrails::Routes.get '/test' do
      redirect 'login'
    end

    response = Wrails.handle_request(method: 'get', path: '/test')
    assert_redirect response
  end

  def test_content_type
    Wrails::Routes.get '/test' do
      content_type :json

      { message: 'ok' }.to_json
    end

    response = Wrails.handle_request(method: 'get', path: '/test')
    assert_json ({ message: 'ok' }), response
  end
end
