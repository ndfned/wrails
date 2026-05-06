require_relative '../lib/wrails'
require_relative '../lib/wrails/routes'

Wrails::Routes.get '/' do
  'Home Page'
end

Wrails::Routes.get '/test' do
  'Hello, world!'
end

Wrails.run!
