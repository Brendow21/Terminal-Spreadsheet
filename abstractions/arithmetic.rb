require_relative '../interfaces/Expression'

# BinaryOperator superclass for all binary operations (Add, Subtract, etc.)
class BinaryOperator
  include Expression

  attr_reader :left, :right, :start_index, :end_index

  def initialize(left, right, start_index = 0, end_index = 0)
    @left = left
    @right = right
    @start_index = start_index
    @end_index = end_index
  end
end

# UnaryOperator superclass for unary operations (Negate, etc.)
class UnaryOperator
  include Expression

  attr_reader :value, :start_index, :end_index

  def initialize(value, start_index = 0, end_index = 0)
    @value = value
    @start_index = start_index
    @end_index = end_index
  end
end

# Add class now inherits from BinaryOperator
class Add < BinaryOperator
  def traverse(visitor, payload)
    visitor.visit_add(self, payload)
  end
end

# Subtract class now inherits from BinaryOperator
class Subtract < BinaryOperator
  def traverse(visitor, payload)
    visitor.visit_subtract(self, payload)
  end
end

# Multiply class now inherits from BinaryOperator
class Multiply < BinaryOperator
  def traverse(visitor, payload)
    visitor.visit_multiply(self, payload)
  end
end

# Divide class now inherits from BinaryOperator
class Divide < BinaryOperator
  def traverse(visitor, payload)
    visitor.visit_divide(self, payload)
  end
end

# Modulo class now inherits from BinaryOperator
class Modulo < BinaryOperator
  def traverse(visitor, payload)
    visitor.visit_modulo(self, payload)
  end
end

# Exponentiation class now inherits from BinaryOperator
class Exponentiation < BinaryOperator
  def traverse(visitor, payload)
    visitor.visit_exponentiation(self, payload)
  end
end

# Negate class now inherits from UnaryOperator
class Negate < UnaryOperator
  def traverse(visitor, payload)
    visitor.visit_negation(self, payload)
  end
end
