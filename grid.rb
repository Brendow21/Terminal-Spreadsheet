require_relative 'evaluator'
require_relative 'runtime'
require_relative 'interpreter/lexer'
require_relative 'interpreter/parser'

class Cell
  attr_accessor :source_code, :ast, :value

  def initialize(source_code = nil, ast = nil, value = nil)
    @source_code = source_code
    @ast = ast
    @value = value
  end
end

class Grid
  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @cells = Array.new(rows) { Array.new(columns) { Cell.new } }
  end

  def set_cell_expression(address, expression)
    if (address.row >= @rows || address.row < 0)
      raise StandardError, "Row of provided address does not exist."
    end

    if (address.col >= @columns || address.col < 0)
      raise StandardError, "Column of provided address does not exist."
    end

    @cells[address.row][address.col].source_code = expression
    @cells[address.row][address.col].value = expression
  end

  def set_cell_formula(address, expression)
    if expression.strip.empty?
      @cells[address.row][address.col].source_code = ""
      @cells[address.row][address.col].value = nil
      return
    end
  
    lexer = Lexer.new(expression)
    tokens = lexer.lex
  
    if tokens.empty?
      raise StandardError, "Lexer failed to tokenize expression '#{expression}'"
    end
  
    parser = Parser.new(tokens)
    ast = parser.parse
  
    if ast.nil?
      raise StandardError, "Parser failed to generate AST for expression '#{expression}'"
    end
  
    @cells[address.row][address.col].source_code = expression
  
    # Ensure that if traverse returns nil, we assign an empty string as the value
    evaluated_value = ast.traverse(Evaluator.new, Runtime.new(self))
    @cells[address.row][address.col].value = evaluated_value.nil? ? "" : evaluated_value.value
  end
  
  
  def get_cell_value(address)
    if (address.row >= @rows || address.row < 0)
      raise StandardError, "Row of provided address does not exist."
    end

    if (address.col >= @columns || address.col < 0)
      raise StandardError, "Column of provided address does not exist."
    end

    cell = @cells[address.row][address.col]

    if cell.source_code.nil?
      return ""
    end

    # Return cell value
    cell.value
  end

  def print_grid
    @cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        value = cell.value.nil? ? "EMPTY" : cell.value
        print "#{value}\t"
      end
      puts
    end
  end
end
