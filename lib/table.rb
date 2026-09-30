# frozen_string_literal: true

class Table
  attr_reader :width, :height

  def initialize(width: 5, height: 5)
    @width = width
    @height = height
  end

  def valid_position?(x, y)
    x >= 0 && x < width && y >= 0 && y < height
  end
end
