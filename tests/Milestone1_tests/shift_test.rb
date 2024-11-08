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
grid = Grid.new(6,6)
runtime = Runtime.new(grid)
grid.set_cell_expression(CellAddress.new(IntegerPrimitive.new(2), IntegerPrimitive.new(4)), IntegerPrimitive.new(2))

shift = LeftShift.new(
  CellRvalue.new(
    Add.new(
      IntegerPrimitive.new(1),
      IntegerPrimitive.new(1)
    ),
    IntegerPrimitive.new(4)
  ),
  IntegerPrimitive.new(3)
)

grid.print_grid
puts
puts shift.traverse(serializer, runtime)
puts shift.traverse(evaluator, runtime).value
