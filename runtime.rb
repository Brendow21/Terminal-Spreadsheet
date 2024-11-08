require_relative 'abstractions/primitives'

class Runtime
  def initialize(grid)
    @grid = grid
  end

  # Fetch a cell value from the grid using column and row.
  def get_cell_value(address)
    @grid.get_cell_value(address)
  end

  # Calculate the maximum value in a rectangular range of cells
  def calculate_max(top_left, bottom_right)
    max_value = -Float::INFINITY
    (top_left.row..bottom_right.row).each do |row|
      (top_left.col..bottom_right.col).each do |col|
        address = CellAddress.new(IntegerPrimitive.new(row), IntegerPrimitive.new(col))
        begin
          value = get_cell_value(address)
          if value.is_a?(Numeric)
            max_value = [max_value, value].max
          end
        rescue StandardError => e
          # Ignore empty cells or cells with invalid values
        end
      end
    end
    max_value == -Float::INFINITY ? nil : max_value
  end

  # Calculate the minimum value in a rectangular range of cells
  def calculate_min(top_left, bottom_right)
    min_value = Float::INFINITY
    (top_left.row..bottom_right.row).each do |row|
      (top_left.col..bottom_right.col).each do |col|
        address = CellAddress.new(IntegerPrimitive.new(row), IntegerPrimitive.new(col))
        begin
          value = get_cell_value(address)
          if value.is_a?(Numeric)
            min_value = [min_value, value].min
          end
        rescue StandardError => e
          # Ignore empty cells or cells with invalid values
        end
      end
    end
    min_value == Float::INFINITY ? nil : min_value
  end

  # Calculate the mean (average) value in a rectangular range of cells
  def calculate_mean(top_left, bottom_right)
    sum = 0
    count = 0
    (top_left.row..bottom_right.row).each do |row|
      (top_left.col..bottom_right.col).each do |col|
        address = CellAddress.new(IntegerPrimitive.new(row), IntegerPrimitive.new(col))
        begin
          value = get_cell_value(address)
          if value.is_a?(Numeric)
            sum += value
            count += 1
          end
        rescue StandardError => e
          # Ignore empty cells or cells with invalid values
        end
      end
    end
    count > 0 ? sum.to_f / count : nil
  end

  # Calculate the sum of values in a rectangular range of cells
  def calculate_sum(top_left, bottom_right)
    sum = 0

    # Iterate through the range of rows and columns between top_left and bottom_right
    (top_left.row..bottom_right.row).each do |row|
      (top_left.col..bottom_right.col).each do |col|
        address = CellAddress.new(IntegerPrimitive.new(row), IntegerPrimitive.new(col))
        begin
          value = get_cell_value(address)
          sum += value.is_a?(Numeric) ? value : 0
        rescue StandardError => e
          # If the cell is empty or any error occurs, treat it as 0
          sum += 0
        end
      end
    end
    sum
  end
end
