require_relative '../interfaces/Expression'

class CellLvalue
  include Expression

  attr_reader :row, :col, :start_index, :end_index

  def initialize(row, col, start_index = 0, end_index = 0)
    # If row is an Integer, wrap it as an IntegerPrimitive
    @row = if row.is_a?(Integer)
             row
           else
             row.traverse(Evaluator.new, Runtime.new(self))
           end

    # Same handling for col
    @col = if col.is_a?(Integer)
             col
           else
             col.traverse(Evaluator.new, Runtime.new(self))
           end

    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_cell_lvalue(self, payload)
  end
end