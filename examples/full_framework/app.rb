# ruby examples/full_framework/app.rb
# open http://localhost:4567

require 'byebug'

require_relative '../../lib/wrails'

require_relative './routes'
require_relative './controllers/home_controller'

Wrails::Config.views_path = 'examples/full_framework/views'

Wrails.run!
