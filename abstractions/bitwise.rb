require_relative '../interfaces/Expression'

class BitwiseAnd
  include Expression

  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index = 0, end_index = 0)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_bitwise_and(self, payload)
  end
end

class BitwiseOr
  include Expression

  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index = 0, end_index = 0)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_bitwise_or(self, payload)
  end
end

class BitwiseXor
  include Expression

  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index = 0, end_index = 0)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_bitwise_xor(self, payload)
  end
end

class BitwiseNot
  include Expression

  attr_reader :value, :start_index, :end_index

  def initialize(value, start_index = 0, end_index = 0)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_bitwise_not(self, payload)
  end
end

class LeftShift
  include Expression

  attr_reader :value, :shift, :start_index, :end_index

  def initialize(value, shift, start_index = 0, end_index = 0)
    @value = value
    @shift = shift
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_left_shift(self, payload)
  end
end

class RightShift
  include Expression

  attr_reader :value, :shift, :start_index, :end_index

  def initialize(value, shift, start_index = 0, end_index = 0)
    @value = value
    @shift = shift
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_right_shift(self, payload)
  end
end