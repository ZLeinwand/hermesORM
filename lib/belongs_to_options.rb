require 'active_support/inflector'
require_relative 'assoc_options'

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || name.to_s.foreign_key.to_sym
    @class_name = options[:class_name] || name.to_s.camelcase
  end
end
