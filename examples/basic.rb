require_relative '../lib/wrails'
require_relative '../lib/wrails/routes'

Wrails::Routes.get '/' do
  'Home Page'
end

Wrails::Routes.get '/test' do
  'Hello, world!'
end

Wrails::Routes.get '/test/:name' do
  "Hello #{params['name']}!"
end

Wrails::Routes.post '/' do
  # create smth
end

Wrails::Routes.delete '/' do
  # delete smth
end

Wrails.run!
