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

runtime = Runtime.new(self)
evaluator = Evaluator.new

# Primitives
int = IntegerPrimitive.new(1, 0, 0)
p int.traverse(evaluator, runtime)

float = FloatPrimitive.new(1, 0, 0)
p float.traverse(evaluator, runtime)

bool = BooleanPrimitive.new(true, 0, 0)
p bool.traverse(evaluator, runtime)

string = StringPrimitive.new("Hello", 0, 0)
p string.traverse(evaluator, runtime)

address = CellAddress.new(2, 2, 0, 0)
p address.traverse(evaluator, runtime)

p
# Arithmetic
add = Add.new(int, int, 0, 0)
p add.traverse(evaluator, runtime)