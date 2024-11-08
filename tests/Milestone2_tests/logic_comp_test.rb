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

great1 = GreaterThan.new(IntegerPrimitive.new(5),IntegerPrimitive.new(3))
great2 = GreaterThan.new(IntegerPrimitive.new(2),IntegerPrimitive.new(8))
a = And.new(great1, great2)

expression = a

puts expression.traverse(serializer, runtime)
lexer = Lexer.new(expression.traverse(serializer, runtime))
tokens = lexer.lex
lexer.print_tokens
parser = Parser.new(tokens)
ast = parser.parse
puts ast.traverse(evaluator, runtime).value
