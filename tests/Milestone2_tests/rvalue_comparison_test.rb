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
require_relative '../../interpreter/lexer'
require_relative '../../interpreter/token'
require_relative '../../interpreter/parser'

evaluator = Evaluator.new
serializer = Serializer.new

# Create Test Grid
grid = Grid.new(6,6)
runtime = Runtime.new(grid)
address_one = CellRvalue.new(
  Subtract.new(
    IntegerPrimitive.new(1),
    IntegerPrimitive.new(1)
  ),
  IntegerPrimitive.new(0)
)
expression_one = Add.new(IntegerPrimitive.new(5), IntegerPrimitive.new(5))
grid.set_cell_expression(address_one, expression_one)
address_two = CellRvalue.new(
  Multiply.new(
    IntegerPrimitive.new(1),
    IntegerPrimitive.new(1)
  ),
  IntegerPrimitive.new(1)
)
grid.set_cell_expression(address_two, IntegerPrimitive.new(1))

expression = LeftShift.new(address_one, address_two)

grid.print_grid
puts 

puts expression.traverse(serializer, runtime)
lexer = Lexer.new(expression.traverse(serializer, runtime))
tokens = lexer.lex
lexer.print_tokens
parser = Parser.new(tokens)
ast = parser.parse
puts ast.traverse(evaluator, runtime).value
