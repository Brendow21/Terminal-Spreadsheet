require_relative '../interfaces/Expression'

class Statistical
  include Expression

  attr_reader :top_left, :bottom_right, :start_index, :end_index

  def initialize(top_left, bottom_right, start_index = 0, end_index = 0)
    @top_left = top_left
    @bottom_right = bottom_right
    @start_index = start_index
    @end_index = end_index
  end
end

class Max < Statistical
  def traverse(visitor, payload)
    visitor.visit_max(self, payload)
  end
end

class Min < Statistical
  def traverse(visitor, payload)
    visitor.visit_min(self, payload)
  end
end

class Mean < Statistical
  def traverse(visitor, payload)
    visitor.visit_mean(self, payload)
  end
end

class Sum < Statistical
  def traverse(visitor, payload)
    visitor.visit_sum(self, payload)
  end
end
