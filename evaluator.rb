require_relative 'interfaces/visitor'
require_relative 'abstractions/primitives'

class Evaluator
  include Visitor

  # Evaluate IntegerPrimitive
  def visit_integer_primitive(node, runtime)
    IntegerPrimitive.new(node.value.to_i, node.start_index, node.end_index)
  end

  # Evaluate FloatPrimitive
  def visit_float_primitive(node, runtime)
    FloatPrimitive.new(node.value.to_f, node.start_index, node.end_index)
  end

  # Evaluate BooleanPrimitive
  def visit_boolean_primitive(node, runtime)
    BooleanPrimitive.new(node.value, node.start_index, node.end_index)
  end

  # Evaluate StringPrimitive
  def visit_string_primitive(node, runtime)
    StringPrimitive.new(node.value, node.start_index, node.end_index)
  end

  # Evaluate Cell Address
  def visit_cell_address(node, runtime)
    CellAddress.new(node.row, node.col, node.start_index, node.end_index)
  end

  # Evaluate Add
  def visit_add(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(left_value.value + right_value.value, node.start_index, node.end_index)
    elsif left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive)
      FloatPrimitive.new(left_value.value + right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Subtract
  def visit_subtract(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(left_value.value - right_value.value, node.start_index, node.end_index)
    elsif left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive)
      FloatPrimitive.new(left_value.value - right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Multiply
  def visit_multiply(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(left_value.value * right_value.value, node.start_index, node.end_index)
    elsif left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive)
      FloatPrimitive.new(left_value.value * right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Divide
  def visit_divide(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(left_value.value / right_value.value, node.start_index, node.end_index)
    elsif left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive) || left_value.is_a?(IntegerPrimitive) && right_value.is_a?(FloatPrimitive) || left_value.is_a?(FloatPrimitive) && right_value.is_a?(IntegerPrimitive)
      FloatPrimitive.new(left_value.value / right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Modulo
  def visit_modulo(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(left_value.value % right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Exponentiation
  def visit_exponentiation(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(left_value.value ** right_value.value, node.start_index, node.end_index)
    elsif left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive)
      FloatPrimitive.new(left_value.value ** right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Negation
  def visit_negation(node, runtime)
    value = node.value.traverse(self, runtime)
    if value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(value.value * -1, node.start_index, node.end_index)
    elsif value.is_a?(FloatPrimitive)
      FloatPrimitive.new(value.value * -1, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{value.class}")
    end
  end

  # Evaluate Logical And
  def visit_and(node, runtime)
    left_value = node.left.traverse(self, runtime).value
    if left_value
      BooleanPrimitive.new(node.right.traverse(self, runtime).value, node.start_index, node.end_index)
    else
      BooleanPrimitive.new(left_value, node.start_index, node.end_index)
    end
  end

  # Evaluate Logical Or
  def visit_or(node, runtime)
    left_value = node.left.traverse(self, runtime).value
    if left_value
      BooleanPrimitive.new(left_value, node.start_index, node.end_index)
    else
      BooleanPrimitive.new(node.right.traverse(self, runtime).value, node.start_index, node.end_index)
    end
  end

  # Evaluate Logical Not
  def visit_not(node, runtime)
    value = node.value.traverse(self, runtime)
    if value.is_a?(BooleanPrimitive)
      BooleanPrimitive.new(!value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{value.class}")
    end
  end

  # Evaluate Bitwise AND
  def visit_bitwise_and(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(left_value.value & right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Bitwise OR
  def visit_bitwise_or(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(left_value.value | right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Bitwise XOR
  def visit_bitwise_xor(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)

    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(left_value.value ^ right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Bitwise NOT
  def visit_bitwise_not(node, runtime)
    value = node.value.traverse(self, runtime)

    if value.is_a?(IntegerPrimitive)
      IntegerPrimitive.new(~value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{value.class}")
    end
  end
  
  def visit_left_shift(node, runtime)
    lhs_value = node.value.traverse(self, runtime)
    rhs_value = node.shift.traverse(self, runtime)
  
    unless lhs_value.is_a?(IntegerPrimitive) && rhs_value.is_a?(IntegerPrimitive)
      return StringPrimitive.new("Type Error: Must be Integer", node.start_index, node.end_index)
    end
  
    IntegerPrimitive.new(lhs_value.value << rhs_value.value, node.start_index, node.end_index)
  end
  
  def visit_right_shift(node, runtime)
    lhs_value = node.value.traverse(self, runtime)
    rhs_value = node.shift.traverse(self, runtime)
  
    unless lhs_value.is_a?(IntegerPrimitive) && rhs_value.is_a?(IntegerPrimitive)
      return StringPrimitive.new("Type Error: Must be Integer", node.start_index, node.end_index)
    end
  
    IntegerPrimitive.new(lhs_value.value >> rhs_value.value, node.start_index, node.end_index)
  end  

  # Evaluate Equals
  def visit_equals(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive)
      BooleanPrimitive.new(left_value.value == right_value.value, node.start_index, node.end_index)
    elsif left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive)
      BooleanPrimitive.new(left_value.value == right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate NotEquals
  def visit_not_equals(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)
    BooleanPrimitive.new(left_value != right_value, node.start_index, node.end_index)
  end

  # Evaluate LessThan
  def visit_less_than(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)

    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive) || left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive)
      BooleanPrimitive.new(left_value.value < right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
    BooleanPrimitive.new(left_value.value < right_value.value, node.start_index, node.end_index)
  end

  # Evaluate LessThanOrEqualTo
  def visit_less_than_or_equal_to(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)

    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive) || left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive)
      BooleanPrimitive.new(left_value.value <= right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate GreaterThan
  def visit_greater_than(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)

    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive) || left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive)
      BooleanPrimitive.new(left_value.value > right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate GreaterThanOrEqualTo
  def visit_greater_than_or_equal_to(node, runtime)
    left_value = node.left.traverse(self, runtime)
    right_value = node.right.traverse(self, runtime)

    if left_value.is_a?(IntegerPrimitive) && right_value.is_a?(IntegerPrimitive) || left_value.is_a?(FloatPrimitive) && right_value.is_a?(FloatPrimitive)
      BooleanPrimitive.new(left_value.value >= right_value.value, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  # Evaluate Float To Int
  def visit_float_to_int(node, runtime)
    value = node.value.traverse(self, runtime)
    if value.is_a?(FloatPrimitive)
      IntegerPrimitive.new(value.value.to_i, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{value.class}")
    end
  end

  # Evaluate Int To Float
  def visit_int_to_float(node, runtime)
    value = node.value.traverse(self, runtime)
    if value.is_a?(IntegerPrimitive)
      FloatPrimitive.new(value.value.to_f, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{value.class}")
    end
  end

  def visit_max(node, runtime)
    max = runtime.calculate_max(node.top_left, node.bottom_right)
    if max.is_a?(Integer)
      IntegerPrimitive.new(max, node.start_index, node.end_index)
    elsif max.is_a?(Float)
      FloatPrimitive.new(max, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  def visit_min(node, runtime)
    min = runtime.calculate_min(node.top_left, node.bottom_right)
    if min.is_a?(Integer)
      IntegerPrimitive.new(min, node.start_index, node.end_index)
    elsif min.is_a?(Float)
      FloatPrimitive.new(min, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  def visit_mean(node, runtime)
    mean = runtime.calculate_mean(node.top_left, node.bottom_right)
    if mean.is_a?(Integer)
      IntegerPrimitive.new(mean, node.start_index, node.end_index)
    elsif mean.is_a?(Float)
      FloatPrimitive.new(mean, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end

  def visit_sum(node, runtime)
    sum = runtime.calculate_sum(node.top_left, node.bottom_right)
    if sum.is_a?(Integer)
      IntegerPrimitive.new(sum, node.start_index, node.end_index)
    elsif sum.is_a?(Float)
      FloatPrimitive.new(sum, node.start_index, node.end_index)
    else
      StringPrimitive.new("Type Error: #{left_value.class} and #{right_value.class}")
    end
  end
  
  # Evaluate CellLValue
  def visit_cell_lvalue(node, runtime)
    row_value = node.row
    col_value = node.col
    if !row_value.is_a?(Integer) || !col_value.is_a?(Integer)
      StringPrimitive.new("Type Error: Must be Integer")
    end
    # Lvalues evaluate to address primitives. They don't trigger a lookup. That's
    # what makes them lvalues rather than rvalues.
    CellAddress.new(row_value, col_value, node.start_index, node.end_index)
  end

  # Evaluate CellRValue
  def visit_cell_rvalue(node, runtime)
    row_value = node.row
    col_value = node.col
    if !row_value.is_a?(Integer) || !col_value.is_a?(Integer)
      StringPrimitive.new("Type Error: Must be Integer")
    end
    result = runtime.get_cell_value(CellAddress.new(
      IntegerPrimitive.new(row_value), 
      IntegerPrimitive.new(col_value), 
      node.start_index, node.end_index))
    if result.is_a?(Integer)
      IntegerPrimitive.new(result, node.start_index, node.end_index)
    elsif result.is_a?(Float)
      FloatPrimitive.new(result, node.start_index, node.end_index)
    elsif [true, false].include? result
      BooleanPrimitive.new(result, node.start_index, node.end_index)
    else
      StringPrimitive.new(result, node.start_index, node.end_index)
    end
  end
end
