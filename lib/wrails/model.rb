module Wrails
  class Model
    class << self
      def all
        DB.execute("SELECT * FROM #{table_name}")
      end

      def create(**params)
        insert_columns = columns - [:id]
        values = insert_columns.map do |column|
          column == :created_at ? Time.now.iso8601 : params[column]
        end

        placeholders = (['?'] * insert_columns.size).join(', ')

        DB.execute(
          "INSERT INTO #{table_name} (#{insert_columns.join(', ')}) VALUES (#{placeholders})",
          values
        )
      end
    end
  end
end
