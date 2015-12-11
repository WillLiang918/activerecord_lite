require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
    # debugger
    self.class_name.constantize
  end

  def table_name
    # ...
    # debugger
    self.class_name.underscore + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # ...
    # debugger
    foreign_key = options[:foreign_key]
    @foreign_key ||= "#{name}_id".to_sym
    @foreign_key = options[:foreign_key] if foreign_key

    class_name = options[:class_name]
    @class_name ||= name.capitalize
    @class_name = options[:class_name] if class_name

    primary_key = options[:primary_key]
    @primary_key ||= :id
    @primary_key = options[:primary_key] if primary_key

  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    foreign_key = options[:foreign_key]
    @foreign_key ||= "#{self_class_name}_id".underscore.to_sym
    @foreign_key = options[:foreign_key] if foreign_key

    class_name = options[:class_name]
    @class_name ||= name.singularize.capitalize
    @class_name = options[:class_name] if class_name

    primary_key = options[:primary_key]
    @primary_key ||= :id
    @primary_key = options[:primary_key] if primary_key
    # ...
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...

    options = BelongsToOptions.new(name, options)
    debugger

    define_method(name.to_sym) do
      # self.model_class.send
      @foreign_key = self.send()
      @class_name = self.model_class
    end





    options = {}
    )





  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
