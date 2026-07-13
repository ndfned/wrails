module Wrails
  class Model
    class << self
      def all
        DB.execute('SELECT * FROM messages')
      end

      def create(**params)
        DB.execute(
          'INSERT INTO messages (text, created_at) VALUES (?, ?)',
          [params[:text], Time.now.iso8601]
        )
      end
    end
  end
end
