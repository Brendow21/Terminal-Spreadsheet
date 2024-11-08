require_relative 'lexer'
require_relative 'token'
require_relative '../abstractions/arithmetic'
require_relative '../abstractions/bitwise'
require_relative '../abstractions/casting'
require_relative '../abstractions/cellLvalue'
require_relative '../abstractions/cellRvalue'
require_relative '../abstractions/logical'
require_relative '../abstractions/primitives'
require_relative '../abstractions/relational'
require_relative '../abstractions/statistical'

class Parser
  def initialize(tokens)
    @tokens = tokens
    @i = 0
  end

  # Check if the current token has the specified type
  def has(type)
    @i < @tokens.size && @tokens[@i].type == type
  end

  # Advance to the next token
  def advance
    @i += 1
  end

  # Starting point
  def parse
    level0
  end

  # Level 0: Logical operators (&&, ||)
  def level0
    left = level1

    # This method demonstrates the recursive descent pattern for
    # left-associative operators nicely: grab the left operand from the rung
    # below, and loop through to collect up right operands as needed.
    while has(:logical_and) || has(:Logical_or)
      if has(:logical_and)
        advance
        right = level1
        left = And.new(left, right, left.start_index, right.end_index)
      elsif has(:logical_or)
        advance
        right = level1
        left = Or.new(left, right, left.start_index, right.end_index)
      end
    end

    left
  end

  # Level 1: Relational operators (=, !=, <, <=, >, >=)
  def level1
    left = level2

    while has(:equals) || has(:not_equals) || has(:less_than) || has(:less_than_or_equal) || has(:greater_than) || has(:greater_than_or_equal)
      if has(:equals)
        advance
        right = level2
        left = Equals.new(left, right, left.start_index, right.end_index)
      elsif has(:not_equals)
        advance
        right = level2
        left = NotEqual.new(left, right, left.start_index, right.end_index)
      elsif has(:less_than)
        advance
        right = level2
        left = LessThan.new(left, right, left.start_index, right.end_index)
      elsif has(:less_than_or_equal)
        advance
        right = level2
        left = LessThanOrEqualTo.new(left, right, left.start_index, right.end_index)
      elsif has(:greater_than)
        advance
        right = level2
        left = GreaterThan.new(left, right, left.start_index, right.end_index)
      elsif has(:greater_than_or_equal)
        advance
        right = level2
        left = GreaterThanOrEqualTo.new(left, right, left.start_index, right.end_index)
      end
    end

    left
  end

  # Level 2: Bitwise operators (&, |, ^)
  def level2
    left = level3

    while has(:bitwise_and) || has(:bitwise_or) || has(:bitwise_xor) || has(:left_shift) || has(:right_shift)
      if has(:bitwise_and)
        advance
        right = level3
        left = BitwiseAnd.new(left, right, left.start_index, right.end_index)
      elsif has(:bitwise_or)
        advance
        right = level3
        left = BitwiseOr.new(left, right, left.start_index, right.end_index)
      elsif has(:bitwise_xor)
        advance
        right = level3
        left = BitwiseXor.new(left, right, left.start_index, right.end_index)
      elsif has(:left_shift)
        advance
        right = level3
        left = LeftShift.new(left, right, left.start_index, right.end_index)
      elsif has(:right_shift)
        advance
        right = level3
        left = RightShift.new(left, right, left.start_index, right.end_index)
      end
    end

    left
  end

  # Level 3: Addition and subtraction (+, -)
  def level3
    left = level4

    while has(:plus) || has(:minus)
      if has(:plus)
        advance
        right = level4
        left = Add.new(left, right, left.start_index, right.end_index)
      elsif has(:minus)
        advance
        right = level4
        left = Subtract.new(left, right, left.start_index, right.end_index)
      end
    end

    left
  end

  # Level 4: Multiplication, division, and modulo (*, /, %)
  def level4
    left = level5

    while has(:multiply) || has(:divide) || has(:modulo)
      if has(:multiply)
        advance
        right = level5
        left = Multiply.new(left, right, left.start_index, right.end_index)
      elsif has(:divide)
        advance
        right = level5
        left = Divide.new(left, right, left.start_index, right.end_index)
      elsif has(:modulo)
        advance
        right = level5
        left = Modulo.new(left, right, left.start_index, right.end_index)
      end
    end

    left
  end

  # Level 5: Exponentiation and unary operators (negate, not, bitwise not)
  def level5
    if has(:negate)
      advance
      expr = level5  # recursively handle additional negations if needed
      Negate.new(expr, expr.start_index, expr.end_index)
    elsif has(:not)
      advance
      expr = level6
      LogicalNot.new(expr, expr.start_index, expr.end_index)
    elsif has(:bitwise_not)
      advance
      expr = level6
      BitwiseNot.new(expr, expr.start_index, expr.end_index)
    else
      left = level6
      if has(:exponent)
        advance
        right = level5  # Right-associative handling with recursion
        left = Exponentiation.new(left, right, left.start_index, right.end_index)
      end
      left
    end
  end

  # Level 6: Casting functions
  def level6
    # Can casts not contain casts?
    if has(:float)
      advance
      expr = level6
      return IntToFloat.new(expr, expr.start_index, expr.end_index)
    elsif has(:int)
      advance
      expr = level6
      return FloatToInt.new(expr, expr.start_index, expr.end_index)
    else
      level7
    end
  end

  # Level 7: Statistical functions, primitives, and grouping
  def level7
    if has(:left_parenthesis)
      advance # Consume '('
      expr = level0 # Parse the expression inside the parentheses
      if !has(:right_parenthesis)
        raise "Expected closing parenthesis"
      end
      advance # Consume ')'
      return expr # Return the parsed expression as a grouped expression
    elsif has(:max)
      advance
      return parse_stat_function(:max)
    elsif has(:min)
      advance
      return parse_stat_function(:min)
    elsif has(:mean)
      advance
      return parse_stat_function(:mean)
    elsif has(:sum)
      advance
      return parse_stat_function(:sum)
    elsif has(:integer_literal)
      token = @tokens[@i]
      advance
      return IntegerPrimitive.new(token.text.to_i, token.start_index, token.end_index)
    elsif has(:float_literal)
      token = @tokens[@i]
      advance
      return FloatPrimitive.new(token.text.to_f, token.start_index, token.end_index)
    elsif has(:boolean_literal)
      token = @tokens[@i]
      advance
      return BooleanPrimitive.new(token.text, token.start_index, token.end_index)
    elsif has(:string_literal)
      token = @tokens[@i]
      advance
      return StringPrimitive.new(token.text, token.start_index, token.end_index)
    elsif has(:hash)
      advance # Consume '#'
      if !has(:left_bracket)
        raise "Expected opening '['"
      end
      advance # Consume '['
      args = []
      loop do
        args << parse
        break unless has(:comma)
        advance # Consume ','
      end

      if !has(:right_bracket)
        raise "Expected closing ']'"
      end
      advance # Consume ']'
      return CellRvalue.new(IntegerPrimitive.new(args[0].value), IntegerPrimitive.new(args[1].value))
    elsif has(:left_bracket)
      advance # Consume '['
      args = []
      loop do
        args << parse
        break unless has(:comma)
        advance # Consume ','
      end

      if !has(:right_bracket)
        raise "Expected closing ']'"
      end
      advance # Consume ']'
      return CellAddress.new(IntegerPrimitive.new(args[0]), IntegerPrimitive.new(args[1]))
    elsif has(:left_parenthesis)
      advance
      expr = parse
      if !has(:right_parenthesis)
        raise "Expected closing parenthesis"
      end
      advance
      return expr
    else
      raise "Unexpected token: #{@tokens[@i]}"
    end
  end

  # Parse statistical function calls with multiple expressions
  def parse_stat_function(func_type)
    if !has(:left_parenthesis)
      raise "Expected '(' after #{func_type}"
    end
    advance # Consume '('

    args = []
    loop do
      args << parse
      break unless has(:comma)
      advance # Consume ','
    end

    if !has(:right_parenthesis)
      raise "Expected closing ')'"
    end
    advance # Consume ')'
    cell1 = CellLvalue.new(args[0].row, args[0].col)
    cell2 = CellLvalue.new(args[1].row, args[1].col)
    case func_type
    when :max then Max.new(cell1, cell2)
    when :min then Min.new(cell1, cell2)
    when :mean then Mean.new(cell1, cell2)
    when :sum then Sum.new(cell1, cell2)
    end
  end
end

