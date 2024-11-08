require_relative '../interfaces/Expression'

class Relational
  include Expression

  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index = 0, end_index = 0)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end
end

class Equals < Relational
  def traverse(visitor, payload)
    visitor.visit_equals(self, payload)
  end
end

class NotEquals < Relational
  def traverse(visitor, payload)
    visitor.visit_not_equals(self, payload)
  end
end

class LessThan < Relational
  def traverse(visitor, payload)
    visitor.visit_less_than(self, payload)
  end
end

class LessThanOrEqualTo < Relational
  def traverse(visitor, payload)
    visitor.visit_less_than_or_equal_to(self, payload)
  end
end

class GreaterThan < Relational
  def traverse(visitor, payload)
    visitor.visit_greater_than(self, payload)
  end
end

class GreaterThanOrEqualTo < Relational
  def traverse(visitor, payload)
    visitor.visit_greater_than_or_equal_to(self, payload)
  end
end
