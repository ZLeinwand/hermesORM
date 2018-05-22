require_relative 'db_connection'
require_relative 'searchable'
require_relative 'associatable'

require 'active_support/inflector'

class SQLObject
  extend Searchable
  extend Associatable



  def self.columns
    @columns ||= DBConnection.execute2("SELECT * FROM #{self.table_name}").first.map(&:to_sym)
  end

  def self.finalize!
    cols = self.columns
    cols.each do |col_name|
      define_method("#{col_name}=") do |arg|
        attributes[col_name] = arg
      end

      define_method(col_name) do
        attributes[col_name]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    data = DBConnection.execute("SELECT * FROM #{self.table_name}")
    self.parse_all(data)
  end

  def self.parse_all(results)
    output = []
    results.each { |atr| output << self.new(atr) }
    output
  end

  def self.find(id)
    data = DBConnection.execute("SELECT * FROM #{self.table_name} WHERE id = ?", id)
    self.parse_all(data).first
  end

  def initialize(params = {})
    params.each do |k,v|
      raise "unknown attribute '#{k.to_s}'" unless self.class.columns.include?(k.to_sym)
      self.send("#{k}=", v)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attributes.values
  end

  def insert
    cols = self.class.columns[1..-1]
    num_qs = cols.length
    qs = (['?'] * num_qs).join(',')
    format_cols = "(#{cols.join(',')})"

    DBConnection.execute2(<<-SQL, attribute_values)
      INSERT INTO
        #{self.class.table_name} #{format_cols}
      VALUES
        (#{qs})
    SQL
    attributes[:id] = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns
    id = attributes[:id]
    cols = cols[1..-1]
    set_line = cols.map { |col| "#{col} = ?"}.join(', ')
    atr = cols.map { |col| attributes[col] } + [id]
    DBConnection.execute2(<<-SQL, atr)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL
  end

  def save
    if attributes[:id]
      update
    else
      insert
    end
  end
end
