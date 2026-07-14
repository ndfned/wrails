require_relative 'test_helper'

require 'sqlite3'

DB = SQLite3::Database.new(':memory:')
DB.results_as_hash = true

DB.execute <<~SQL
  CREATE TABLE messages (
    id INTEGER PRIMARY KEY,
    text TEXT,
    created_at TEXT
  );
SQL

class Message < Wrails::Model
  class << self
    def table_name
      'messages'
    end

    def columns
      %i[id text created_at]
    end
  end
end

class MessageTest < Minitest::Test
  def test_create
    Message.create(text: 'Hello')

    rows = Message.all

    assert_equal 1, rows.size
    assert_equal 'Hello', rows.first['text']
    refute_nil rows.first['created_at']
  end
end
