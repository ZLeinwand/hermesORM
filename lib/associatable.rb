require_relative 'belongs_to_options'
require_relative 'has_many_options'

module Associatable

  def belongs_to(name, options = {})
    belongs_to_object = BelongsToOptions.new(name, options)

    assoc_options[name] = belongs_to_object

    define_method(name) do
      foreign_key_name = self.class.assoc_options[name].foreign_key
      foreign_key_id = self.send("#{foreign_key_name}")
      class_name = self.class.assoc_options[name].model_class
      class_name.find(foreign_key_id)
    end
  end

  def has_many(name, options = {})
    has_many_object = HasManyOptions.new(name, self.to_s, options)

    assoc_options[name] = has_many_object

    define_method(name) do
      foreign_key_name = self.class.assoc_options[name].foreign_key
      class_name = self.class.assoc_options[name].model_class
      where_hash = {}
      where_hash["#{foreign_key_name}"] = self.id
      class_name.where(where_hash)
    end
  end

  def has_one_through(name, through_name, source_name)

    define_method("#{name}") do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      data = DBConnection.execute(<<-SQL, self.id)
        SELECT "#{source_options.table_name}".* FROM "#{source_options.table_name}"
        JOIN "#{through_options.table_name}" on "#{source_options.table_name}"."#{source_options.primary_key}" = "#{through_options.table_name}"."#{source_options.foreign_key}"
        JOIN "#{self.class.table_name}" on "#{self.class.table_name}"."#{through_options.foreign_key}" = "#{through_options.table_name}"."#{through_options.primary_key}"
        WHERE "#{self.class.table_name}".id = ?
      SQL
      source_options.model_class.parse_all(data).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

end
