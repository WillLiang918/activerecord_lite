require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...

    columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    columns.first.map! do |column|
      column.to_sym
    end
  end

  def self.finalize!
    self.columns.each do |column|

      define_method("#{column}=") do |value|
        self.attributes[column] = value
      end

      define_method(column) do
        self.attributes[column]
      end
    end

  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    @table_name ||= "#{self}".tableize
  end

  def self.all
    # ...
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*

      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    # ...
    all_cats = []
    results.each do |result|
      all_cats << self.new(result)
    end

    all_cats
  end

  def self.find(id)
    # ...
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
      LIMIT
        1
    SQL
      parse_all(results).first
  end

  def initialize(params = {})
    # ...
    params.each do |attr_name, value|
      raise ("unknown attribute '#{attr_name}'") unless self.class.columns.include?(attr_name.to_sym)
      self.send("#{attr_name}=".to_sym, value)
    end

  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
    attr_values = {}
    self.class.columns.map do |column|
      attr_values[column] = self.send(column)
    end

    attr_values.values

  end

  def insert
    # ...
    col_names = self.class.columns[1..-1].join(', ')
    question_marks = attribute_values[1..-1].map { |value|
      "?" }.join(', ')
    insert_row = "#{self.class.table_name} (#{col_names})"

    DBConnection.execute(<<-SQL, *attribute_values[1..-1])
      INSERT INTO
        #{insert_row}
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    # ...
    set_line = self.class.columns[1..-1].map do |cols|
      "#{cols} = ?"
    end
    set_line = set_line.join(', ')

    DBConnection.execute(<<-SQL, attribute_values[1..-1], attribute_values[0])
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL
  end

  def save
    # ...
    if self.id.nil?
      self.insert
    else
      self.update
    end
  end
end
