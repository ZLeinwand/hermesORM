require_relative '../lib/sql_object'

class House < SQLObject
  has_many :humans

  finalize!
end
