require_relative '../lib/sql_object'
require_relative 'human'
require_relative 'house'

class Dog < SQLObject
  belongs_to :human,
  foreign_key: :owner_id,
  class_name: :Human

  has_one_through :home, :human, :house
  
  finalize!
end
