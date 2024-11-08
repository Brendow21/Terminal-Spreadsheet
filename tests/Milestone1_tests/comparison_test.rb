require_relative '../../evaluator'
require_relative '../../interfaces/Expression'
require_relative '../../grid'
require_relative '../../runtime'
require_relative '../../serializer'
require_relative '../../interfaces/visitor'
require_relative '../../abstractions/arithmetic'
require_relative '../../abstractions/primitives'
require_relative '../../abstractions/bitwise'
require_relative '../../abstractions/casting'
require_relative '../../abstractions/cellLvalue'
require_relative '../../abstractions/cellRvalue'
require_relative '../../abstractions/logical'
require_relative '../../abstractions/relational'
require_relative '../../abstractions/statistical'

evaluator = Evaluator.new
serializer = Serializer.new

# Create Test Grid
grid = Grid.new(3,3)
runtime = Runtime.new(grid)
grid.set_cell_expression(CellAddress.new(0, 0), IntegerPrimitive.new(2))
grid.set_cell_expression(CellAddress.new(0, 1), IntegerPrimitive.new(1))

compare = LessThan.new(
  CellRvalue.new(IntegerPrimitive.new(0), IntegerPrimitive.new(0)),
  CellRvalue.new(IntegerPrimitive.new(0), IntegerPrimitive.new(1))
)

grid.print_grid
puts
puts compare.traverse(serializer, runtime)
puts compare.traverse(evaluator, runtime).value
