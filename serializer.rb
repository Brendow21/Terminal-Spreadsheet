require_relative 'interfaces/visitor'

class Serializer
  include Visitor

  # Primitives
  def visit_integer_primitive(node, _payload)
    node.value.to_s
  end

  def visit_float_primitive(node, _payload)
    node.value.to_s
  end

  def visit_boolean_primitive(node, _payload)
    node.value.to_s
  end

  def visit_string_primitive(node, _payload)
    "\"#{node.value}\""
  end

  def visit_cell_address(node, _payload)
    # Good clean stringing. Interpolation > concatenation.
    "[#{node.row},#{node.col}]"
  end

  # Arithmetic
  def visit_add(node, _payload)
    "(#{node.left.traverse(self, nil)} + #{node.right.traverse(self, nil)})"
  end

  def visit_subtract(node, _payload)
    "(#{node.left.traverse(self, nil)} - #{node.right.traverse(self, nil)})"
  end

  def visit_multiply(node, _payload)
    "(#{node.left.traverse(self, nil)} * #{node.right.traverse(self, nil)})"
  end

  def visit_divide(node, _payload)
    "(#{node.left.traverse(self, nil)} / #{node.right.traverse(self, nil)})"
  end

  def visit_modulo(node, _payload)
    "(#{node.left.traverse(self, nil)} % #{node.right.traverse(self, nil)})"
  end

  def visit_exponentiation(node, _payload)
    "(#{node.left.traverse(self, nil)} ** #{node.right.traverse(self, nil)})"
  end

  def visit_negation(node, _payload)
    "-#{node.value.traverse(self, nil)}"
  end

  # Logical
  def visit_and(node, _payload)
    "(#{node.left.traverse(self, nil)} && #{node.right.traverse(self, nil)})"
  end

  def visit_or(node, _payload)
    "(#{node.left.traverse(self, nil)} || #{node.right.traverse(self, nil)})"
  end

  def visit_not(node, _payload)
    "!(#{node.value.traverse(self, nil)})"
  end

  # Bitwise
  def visit_bitwise_and(node, _payload)
    "(#{node.left.traverse(self, nil)} & #{node.right.traverse(self, nil)})"
  end

  def visit_bitwise_or(node, _payload)
    "(#{node.left.traverse(self, nil)} | #{node.right.traverse(self, nil)})"
  end

  def visit_bitwise_xor(node, _payload)
    "(#{node.left.traverse(self, nil)} ^ #{node.right.traverse(self, nil)})"
  end

  def visit_bitwise_not(node, _payload)
    "~#{node.value.traverse(self, nil)}"
  end

  def visit_left_shift(node, _payload)
    "(#{node.value.traverse(self, nil)} << #{node.shift.traverse(self, nil)})"
  end

  def visit_right_shift(node, _payload)
    "(#{node.value.traverse(self, nil)} >> #{node.shift.traverse(self, nil)})"
  end

  # Relational
  def visit_equals(node, _payload)
    "(#{node.left.traverse(self, nil)} == #{node.right.traverse(self, nil)})"
  end

  def visit_not_equals(node, _payload)
    "(#{node.left.traverse(self, nil)} != #{node.right.traverse(self, nil)})"
  end

  def visit_less_than(node, _payload)
    "(#{node.left.traverse(self, nil)} < #{node.right.traverse(self, nil)})"
  end

  def visit_less_than_or_equal_to(node, _payload)
    "(#{node.left.traverse(self, nil)} <= #{node.right.traverse(self, nil)})"
  end

  def visit_greater_than(node, _payload)
    "(#{node.left.traverse(self, nil)} > #{node.right.traverse(self, nil)})"
  end

  def visit_greater_than_or_equal_to(node, _payload)
    "(#{node.left.traverse(self, nil)} >= #{node.right.traverse(self, nil)})"
  end

  # Casting
  def visit_float_to_int(node, _payload)
    "int(#{node.value.traverse(self, nil)})"
  end

  def visit_int_to_float(node, _payload)
    "float(#{node.value.traverse(self, nil)})"
  end

  # Statistical
  def visit_max(node, _payload)
    "max(#{node.top_left.traverse(self, nil)}, #{node.bottom_right.traverse(self, nil)})"
  end

  def visit_min(node, _payload)
    "min(#{node.top_left.traverse(self, nil)}, #{node.bottom_right.traverse(self, nil)})"
  end

  def visit_mean(node, _payload)
    "mean(#{node.top_left.traverse(self, nil)}, #{node.bottom_right.traverse(self, nil)})"
  end

  def visit_sum(node, _payload)
    "sum(#{node.top_left.traverse(self, nil)}, #{node.bottom_right.traverse(self, nil)})"
  end

  # Cell L Value
  def visit_cell_lvalue(node, _payload)
    "[#{node.row}, #{node.col}]"
  end

  # Cell R Value
  def visit_cell_rvalue(node, _payload)
    "#[#{node.row}, #{node.col}]"
  end
end
