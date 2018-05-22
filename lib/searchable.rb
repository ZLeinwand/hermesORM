require_relative 'db_connection'


module Searchable
  def where(params)
    cols = params.keys.map { |atr| "#{atr} = ?"}.join(' AND ')
    vals = params.values

    data = DBConnection.execute(<<-SQL, vals)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{cols}
    SQL

    data.map { |datum| self.new(datum) }
  end
end
