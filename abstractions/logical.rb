require_relative '../interfaces/Expression'

class And
  include Expression

  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index = 0, end_index = 0)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_and(self, payload)
  end
end

class Or
  include Expression

  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index = 0, end_index = 0)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_or(self, payload)
  end
end

class Not
  include Expression

  attr_reader :value, :start_index, :end_index

  def initialize(value, start_index = 0, end_index = 0)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_not(self, payload)
  end
end