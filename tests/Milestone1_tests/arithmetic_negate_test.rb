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

# # Create Test Grid
grid = Grid.new(5,5)
runtime = Runtime.new(grid)
cell1 = CellRvalue.new(IntegerPrimitive.new(3), IntegerPrimitive.new(1))
grid.set_cell_expression(cell1, IntegerPrimitive.new(2))

cell2 = CellRvalue.new(IntegerPrimitive.new(2), IntegerPrimitive.new(1))
grid.set_cell_expression(cell2, IntegerPrimitive.new(2))

# Test Arithmetic negation and cell rvalues
product = Multiply.new(
  cell1,
  Negate.new(cell2)
)

# grid.print_grid
# puts
puts product.traverse(serializer, runtime)
puts product.traverse(evaluator, runtime).value