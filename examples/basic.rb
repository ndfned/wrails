# ruby examples/basic.rb
# open http://localhost:4567

require_relative '../lib/wrails'
require_relative '../lib/wrails/routes'
require 'byebug'

Wrails::Config.views_path = 'examples/views'

Wrails::Routes.get '/' do
  'Home Page'
end

Wrails::Routes.get '/test' do
  'Hello, world!'
end

Wrails::Routes.get '/test/:name' do
  "Hello #{params['name']}!"
end

Wrails::Routes.get '/template1' do
  erb :template1
end

Wrails::Routes.post '/' do
  # create smth
end

# Wrails::Routes.delete '/' do
#   # delete smth
# end

Wrails.run!
