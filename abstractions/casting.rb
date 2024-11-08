require_relative '../interfaces/Expression'

class FloatToInt
  include Expression

  attr_reader :value, :start_index, :end_index

  def initialize(value, start_index = 0, end_index = 0)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_float_to_int(self, payload)
  end
end

class IntToFloat
  include Expression

  attr_reader :value, :start_index, :end_index

  def initialize(value, start_index = 0, end_index = 0)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_int_to_float(self, payload)
  end
end