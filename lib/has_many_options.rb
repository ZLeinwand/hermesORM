require 'active_support/inflector'
require_relative 'assoc_options'

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || self_class_name.foreign_key.to_sym
    @class_name = options[:class_name] || name.to_s.camelcase.singularize
  end
end
