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
runtime = Runtime.new(self)

add = Add.new(
  IntegerPrimitive.new(5),
  IntegerPrimitive.new(2)
)
multiply = Multiply.new(
  add,
  IntegerPrimitive.new(3)
)
mod = Modulo.new(
  multiply,
  IntegerPrimitive.new(4)
)

expression = mod

puts expression.traverse(serializer, runtime)
lexer = Lexer.new(expression.traverse(serializer, runtime))
tokens = lexer.lex
lexer.print_tokens
parser = Parser.new(tokens)
ast = parser.parse
puts ast.traverse(evaluator, runtime).value
