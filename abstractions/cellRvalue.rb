require_relative '../interfaces/Expression'

class CellRvalue
  include Expression

  attr_reader :row, :col, :start_index, :end_index

  def initialize(row, col, start_index = 0, end_index = 0)
    @row = row.traverse(Evaluator.new, Runtime.new(self)).value
    @col = col.traverse(Evaluator.new, Runtime.new(self)).value
    @start_index = start_index
    @end_index = end_index
  end

  def traverse(visitor, payload)
    visitor.visit_cell_rvalue(self, payload)
  end
end