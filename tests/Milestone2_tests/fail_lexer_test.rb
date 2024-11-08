require_relative '../../interpreter/lexer'
require_relative '../../interpreter/token'
require_relative '../../interpreter/parser'
require_relative '../../evaluator'
require_relative '../../runtime'

malformed_inputs = [
  "if(x > 5)",              # No if statement support
  "sum(1, 2)",              # Invalid use of sum
  "int(10",                 # Missing closing parethesis
  "10.0.0"                  # Invalid float
]

valid_inputs = [
  "2 ** 3 ** 2",
  "int(float(2))"
]

# expression = malformed_inputs[4]
expression = valid_inputs[1]

lexer = Lexer.new(expression)
tokens = lexer.lex
lexer.print_tokens
parser = Parser.new(tokens)
ast = parser.parse
puts ast.traverse(Evaluator.new, Runtime.new(self)).value
