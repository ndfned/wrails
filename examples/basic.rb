# ruby examples/basic.rb
# open http://localhost:4567

require 'byebug'
require 'json'

require_relative '../lib/wrails'
require_relative '../lib/wrails/routes'

Wrails::Config.views_path = 'examples/views'

Wrails::Routes.get '/' do
  'Home Page'
end

Wrails::Routes.get '/test' do
  'Hello, world!'
end

Wrails::Routes.get '/test_qparams' do |params|
  "Hello #{params[:name].capitalize} #{params[:lastname].capitalize}!"
end

Wrails::Routes.get '/test/:name' do |params|
  "Hello #{params[:name]}!"
end

Wrails::Routes.get '/not_found' do |params|
  if params[:name].nil?
    response.status = 404
    'Not found'
  else
    "Hello #{params[:name]}!"
  end
end

Wrails::Routes.get '/redirect' do
  redirect '/'
end

Wrails::Routes.get '/json' do
  content_type :json

  { message: 'ok' }.to_json
end

Wrails::Routes.get '/headers' do
  headers 'X-Test', '123'

  'ok'
end

Wrails::Routes.get '/template1' do
  erb :template1, locals: { name: 'John' }
end

Wrails::Routes.post '/' do
  # create smth
end

Wrails::Routes.put '/' do
  # replace smth
end

Wrails::Routes.patch '/' do
  # modify smth
end

Wrails::Routes.delete '/' do
  # delete smth
end

Wrails.run!
