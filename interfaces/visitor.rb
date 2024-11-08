# Visitor module for the visitor pattern.
# No need to raise NotImplementedError for each method; the Ruby interpreter will
# handle missing methods at runtime with NoMethodError.
module Visitor
  # Visit methods for primitive expressions
  def visit_integer_primitive(node, payload); end
  def visit_float_primitive(node, payload); end
  def visit_boolean_primitive(node, payload); end
  def visit_string_primitive(node, payload); end
  def visit_cell_address(node, payload); end

  # Visit methods for arithmetic operations
  def visit_add(node, payload); end
  def visit_subtract(node, payload); end
  def visit_multiply(node, payload); end
  def visit_divide(node, payload); end
  def visit_modulo(node, payload); end
  def visit_exponentiation(node, payload); end
  def visit_negation(node, payload); end

  # Visit methods for logical operations
  def visit_and(node, payload); end
  def visit_or(node, payload); end
  def visit_not(node, payload); end

  # Visit methods for bitwise operations
  def visit_bitwise_and(node, payload); end
  def visit_bitwise_or(node, payload); end
  def visit_bitwise_xor(node, payload); end
  def visit_bitwise_not(node, payload); end
  def visit_left_shift(node, payload); end
  def visit_right_shift(node, payload); end

  # Visit methods for relational operations
  def visit_equals(node, payload); end
  def visit_not_equals(node, payload); end
  def visit_less_than(node, payload); end
  def visit_less_than_or_equal_to(node, payload); end
  def visit_greater_than(node, payload); end
  def visit_greater_than_or_equal_to(node, payload); end

  # Visit methods for casting operations
  def visit_float_to_int(node, payload); end
  def visit_int_to_float(node, payload); end

  # Visit methods for statistical functions
  def visit_max(node, payload); end
  def visit_min(node, payload); end
  def visit_mean(node, payload); end
  def visit_sum(node, payload); end

  # Visit methods for cell value expressions
  def visit_cell_lvalue(node, payload); end
  def visit_cell_rvalue(node, payload); end
end
