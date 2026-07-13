# ruby examples/full_framework/app.rb
# open http://localhost:4567

require 'byebug'

require_relative '../../lib/wrails'

require_relative './routes'
require_relative './controllers/home_controller'

Wrails::Config.views_path = 'examples/full_framework/views'

require 'sqlite3'
DB = SQLite3::Database.new('app.db')
DB.results_as_hash = true

DB.execute <<~SQL
  CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    text TEXT NOT NULL,
    created_at TEXT NOT NULL
  );
SQL

class Message < Wrails::Model
end

Wrails.run!
