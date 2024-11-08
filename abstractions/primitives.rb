require_relative '../interfaces/Expression'

class Primitive
  include Expression

  attr_reader :value, :start_index, :end_index

  def initialize(value, start_index = 0, end_index = 0)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end
end

class IntegerPrimitive < Primitive
  def traverse(visitor, payload)
    visitor.visit_integer_primitive(self, payload)
  end
end

class FloatPrimitive < Primitive
  def traverse(visitor, payload)
    visitor.visit_float_primitive(self, payload)
  end
end

class BooleanPrimitive < Primitive
  def traverse(visitor, payload)
    visitor.visit_boolean_primitive(self, payload)
  end
end

class StringPrimitive < Primitive
  def traverse(visitor, payload)
    visitor.visit_string_primitive(self, payload)
  end
end

class CellAddress
  include Expression

  attr_reader :row, :col, :start_index, :end_index

  def initialize(row, col, start_index = 0, end_index = 0)
    @row = row.value
    @col = col.value
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_cell_address(self, payload)
  end
end
