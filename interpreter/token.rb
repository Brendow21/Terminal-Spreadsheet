class Token
  attr_reader :type, :text, :start_index, :end_index

  def initialize(type, text, start_index, end_index)
    @type = type           # The type of token (e.g., :integer_literal, :plus, etc.)
    @text = text           # The raw text for this token (e.g., "5", "+", "32.0")
    @start_index = start_index  # The starting index of the token in the source text
    @end_index = end_index      # The ending index of the token in the source text
  end

  def to_s
    "(#{@type}, \"#{@text}\", #{@start_index}, #{@end_index})"
  end
end
