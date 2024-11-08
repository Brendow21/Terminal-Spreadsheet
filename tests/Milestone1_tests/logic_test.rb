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

# Create runtime
runtime = Runtime.new(self)
evaluator = Evaluator.new
serializer = Serializer.new

logic = Not.new(
  GreaterThan.new(
    FloatPrimitive.new(3.3),
    FloatPrimitive.new(3.2)
  )
)

puts
puts logic.traverse(serializer, runtime)
puts logic.traverse(evaluator, runtime).value
