require_relative '../../evaluator'
require_relative '../../interfaces/expression'
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

# Create Runtime
runtime = Runtime.new(self)
evaluator = Evaluator.new
serializer = Serializer.new

# Test Arithmetic
modulus = Modulo.new(
  Add.new(
    Multiply.new(
      IntegerPrimitive.new(7),
      IntegerPrimitive.new(4)
    ),
    IntegerPrimitive.new(3)
  ),
  IntegerPrimitive.new(12)
)
puts "Arithmetic Test"
puts modulus.traverse(serializer, runtime)
puts modulus.traverse(evaluator, runtime).value
puts

modulus_fail = Modulo.new(
  Add.new(
    Multiply.new(
      7,
      IntegerPrimitive.new(4)
    ),
    IntegerPrimitive.new(3)
  ),
  IntegerPrimitive.new(12)
)
# puts "Arithmetic Test Fail"
# puts modulus_fail.traverse(serializer, runtime)