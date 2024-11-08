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
  IntegerPrimitive.new(0),
  IntegerPrimitive.new(0)
)
expression_one = Add.new(IntegerPrimitive.new(5), IntegerPrimitive.new(5))
grid.set_cell_expression(address_one, expression_one)

rvalue = address_one
shift = IntegerPrimitive.new(3)

expression = Add.new(rvalue, shift)

grid.print_grid
puts 

puts expression.traverse(serializer, runtime)
lexer = Lexer.new(expression.traverse(serializer, runtime))
tokens = lexer.lex
lexer.print_tokens
parser = Parser.new(tokens)
ast = parser.parse
puts ast.traverse(evaluator, runtime).value
