require_relative '../lib/sql_object'

class Human < SQLObject
  has_many :dogs,
    foreign_key: :owner_id,
    class_name: :Dog

  belongs_to :house

  self.table_name = :humans
  finalize!
end
