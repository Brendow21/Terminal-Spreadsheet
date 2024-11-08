require_relative 'token'

class Lexer

  def initialize(source)
    @source = source
    @i = 0
    @token_so_far = ''
    @tokens = []
    @start_index = 0
  end

  def has(target)
    # This looks like a grammar. Left-associative operators recurse on the left
    # and descend on the right. Right-associative operators flip. There are
    # cleanly divided precedence levels.
    @source[@i] == target
  end

  def has_alphabetic
    ('a'..'z').include?(@source[@i]) || ('A'..'Z').include?(@source[@i])
  end

  def has_digit
    ('0'..'9').include?(@source[@i])
  end

  def capture
    @token_so_far += @source[@i]
    @i += 1
  end

  def emit_token(type)
    @tokens.push(Token.new(type, @token_so_far, @start_index, @i - 1))
    @token_so_far = ''
  end

  def lex
    while @i < @source.size
      @start_index = @i
      if has(' ')
        @i += 1
      elsif has('(')
        capture
        emit_token(:left_parenthesis)
      elsif has(')')
        capture
        emit_token(:right_parenthesis)
      elsif has('[')
        capture
        emit_token(:left_bracket)
      elsif has(']')
        capture
        emit_token(:right_bracket)
      elsif has(',')
        capture
        emit_token(:comma)
      elsif has('#')
        capture
        emit_token(:hash)
      elsif has('&')
        capture
        if has('&')
          capture
          emit_token(:logical_and)
        else
          emit_token(:bitwise_and)
        end
      elsif has('|')
        capture
        if has('|')
          capture
          emit_token(:logical_or)
        else
          emit_token(:bitwise_or)
        end
      elsif has('~')
        capture
        emit_token(:bitwise_not)
      elsif has('^')
        capture
        emit_token(:bitwise_xor)
      elsif has('+')
        capture
        emit_token(:plus)
      elsif has('-')
        capture
        if has(' ')
          emit_token(:minus)
        else
          emit_token(:negate)
        end
      elsif has('*')
        capture
        if has('*')
          capture
          emit_token(:exponent)
        else
          emit_token(:multiply)
        end
      elsif has('/')
        capture
        emit_token(:divide)
      elsif has('%')
        capture
        emit_token(:modulo)
      elsif has('!')
        capture
        if has('=')
          capture
          emit_token(:not_equal)
        else
          emit_token(:not)
        end
      elsif has('=')
        capture
        if has('=')
          capture
          emit_token(:equals)
        end
      elsif has('<')
        capture
        if has('=')
          capture
          emit_token(:less_than_or_equal)
        elsif has('<')
          capture
          emit_token(:left_shift)
        else
          emit_token(:less_than)
        end
      elsif has('>')
        capture
        if has('=')
          capture
          emit_token(:greater_than_or_equal)
        elsif has('>')
          capture
          emit_token(:right_shift)
        else
          emit_token(:greater_than)
        end
      elsif has_digit
        while has_digit
          capture
        end
        # Check for float
        if has('.')
          capture
          while has_digit
            capture
          end
          emit_token(:float_literal)
        else
          emit_token(:integer_literal)
        end
      elsif has_alphabetic
        while has_alphabetic || has_digit
          capture
        end
        case @token_so_far
        when "max"
          emit_token(:max)
        when "min"
          emit_token(:min)
        when "mean"
          emit_token(:mean)
        when "sum"
          emit_token(:sum)
        when "float"
          emit_token(:float)
        when "int"
          emit_token(:int)
        when "true", "false"
          emit_token(:boolean_literal)
        else
          emit_token(:string_literal)
        end
      else
        raise "Unexpected character '#{@source[@i]}' at index #{@i}"
      end
    end
    @tokens
  end

  def print_tokens()
    puts
    @tokens.each { |token| puts "#{token.type}: \"#{token.text}\" (#{token.start_index}-#{token.end_index})" }
    puts
  end
end
