require 'curses'
require_relative '../abstractions/primitives'
require_relative '../grid'
require_relative '../evaluator'
require_relative '../runtime'

class Spreadsheet
  def initialize
    Curses::init_screen
    Curses::curs_set(1)

    @width = 10
    @height = 10
    @cell_data = Grid.new(@height, @width)
    @cell_formulas = Array.new(@height) { Array.new(@width, '') }
    @dependencies = Hash.new { |hash, key| hash[key] = [] }

    # Windows for display
    @grid_window = Curses::Window.new(@height * 2 + 3, @width * 12 + 2, 3, 0)
    @message_window = Curses::Window.new(1, Curses::cols, 0, 0)
    @formula_window = Curses::Window.new(3, Curses::cols / 2, 0, 0)
    @display_window = Curses::Window.new(3, Curses::cols / 2, 0, Curses::cols / 2)

    @current_row = 0
    @current_col = 0
  end

  # Render
  def render_grid
    @grid_window.clear

    # Top Border
    @grid_window.setpos(0, 0)
    @grid_window.addstr("┌#{'─' * (@width * 12 - 1)}┐")

    # Grid Rows
    (0...@height).each do |row|
      @grid_window.setpos(row * 2 + 1, 0)
      @grid_window.addstr("│")
      (0...@width).each do |col|
        address = CellAddress.new(IntegerPrimitive.new(row), IntegerPrimitive.new(col))
        value = @cell_data.get_cell_value(address)
        display_value = value.nil? || value.to_s.empty? ? format_cell(" ") : format_cell(value)
        @grid_window.addstr(" #{display_value}│")
      end

      # Inner border for each row
      @grid_window.setpos(row * 2 + 2, 0)
      @grid_window.addstr("├#{'─' * (@width * 12 - 1)}┤")
    end

    # Bottom Border
    @grid_window.setpos(@height * 2, 0)
    @grid_window.addstr("└#{'─' * (@width * 12 - 1)}┘")

    # Highlight selected cell
    @grid_window.setpos(@current_row * 2 + 1, @current_col * 12 + 1)
    address = CellAddress.new(IntegerPrimitive.new(@current_row), IntegerPrimitive.new(@current_col))
    value = @cell_data.get_cell_value(address)
    display_value = value.nil? || value.to_s.empty? ? format_cell(" ") : format_cell(value)

    @grid_window.attron(Curses::A_REVERSE) do
      @grid_window.addstr(display_value)
    end

    @grid_window.refresh
  end

  # Format value to fit within cell
  def format_cell(value)
    value.to_s[0, 9].ljust(10)
  end

  # Render Formula Editor
  def render_formula_editor
    @formula_window.clear
    @formula_window.setpos(1, 0)
    formula = @cell_formulas[@current_row][@current_col]
    @formula_window.addstr("Editing: #{formula.empty? ? 'Empty' : formula}")
    @formula_window.refresh
  end

  # Render Display Panel
  def render_display_panel
    @display_window.clear
    @display_window.setpos(1, 0)
    address = CellAddress.new(IntegerPrimitive.new(@current_row), IntegerPrimitive.new(@current_col))
    value = @cell_data.get_cell_value(address)
    @display_window.addstr("Value: #{value.nil? ? 'Empty' : value}")
    @display_window.refresh
  end

  # Spreadsheet keys
  def handle_input
    case @grid_window.getch
    when 'q'
      return false
    when 'w'
      @current_row = [@current_row - 1, 0].max
    when 's'
      @current_row = [@current_row + 1, @height - 1].min
    when 'a'
      @current_col = [@current_col - 1, 0].max
    when 'd'
      @current_col = [@current_col + 1, @width - 1].min
    when 'e'
      enter_edit_mode
    end
    true
  end

  # Edit Cell
  def enter_edit_mode
    input = @cell_formulas[@current_row][@current_col].dup

    # Clear the editing area if the cell is empty
    input.clear if input.empty?

    @formula_window.setpos(1, 9)
    @formula_window.clrtoeol
    @formula_window.addstr("#{input}")
    @formula_window.refresh

    loop do
      ch = @formula_window.getch

      case ch
      when 10  # Enter key
        periodic_update
        break
      when 8, 127 # Backspace key
        input.chop! unless input.empty?
      when 27  # ESC key: Exit without saving
        return
      else
        input << ch if ch.is_a?(String) && ch.match?(/[[:print:]]/)
      end

      # Update display with current input
      @formula_window.setpos(1, 9)
      @formula_window.clrtoeol
      @formula_window.addstr("#{input}")
      @formula_window.refresh
    end

    # Update or clear cell based on final input
    update_cell(input)
  end

  # Update cell with input
  def update_cell(input)
    @cell_formulas[@current_row][@current_col] = input
    evaluate_cell(@current_row, @current_col)
    periodic_update
  end

  # Evaluate cell and store expression
  def evaluate_cell(row, col)
    formula = @cell_formulas[row][col]
    address = CellAddress.new(IntegerPrimitive.new(row), IntegerPrimitive.new(col))
    if formula.start_with?('=')
      formula = formula[1..-1]
      @cell_data.set_cell_formula(address, formula)
    else
      if integer?(formula) || float?(formula) || bool?(formula)
        @cell_data.set_cell_formula(address, formula)
      else
        @cell_data.set_cell_expression(address, formula)
      end
    end
  end

  # Periodic updates
  def periodic_update
    # Evaluate all cells
    (0...@height).each do |row|
      (0...@width).each do |col|
        evaluate_cell(row, col)
      end
    end
  end

  def integer?(str)
    str.match(/^[-]?\d+$/)
  end

  def float?(str)
    str.match(/^[-]?\d+\.+\d+$/)
  end

  def bool?(str)
    [true, false].include? str
  end

  def render
    loop do
      render_formula_editor
      render_display_panel
      render_grid
      periodic_update
      @message_window.clear
      @message_window.setpos(0, 0)
      @message_window.addstr("Use WASD to move, E to edit, Q to quit.")
      @message_window.refresh

      break unless handle_input
    end
  ensure
    Curses::close_screen
  end
end

spreadsheet = Spreadsheet.new
spreadsheet.render
