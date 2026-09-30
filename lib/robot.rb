# frozen_string_literal: true

class Robot
  attr_reader :x, :y, :direction

  DIRECTIONS = %w[NORTH EAST SOUTH WEST]

  MOVEMENTS = {
    "NORTH" => [0, 1],    # x doesn't change, y goes up 1
    "SOUTH" => [0, -1],   # y goes down 1
    "EAST"  => [1, 0],    # x goes up 1
    "WEST"  => [-1, 0]    # x goes down 1
  }

  def place(x:, y:, direction:)
    return unless DIRECTIONS.include?(direction)

    @x = x
    @y = y
    @direction = direction
  end

  def left
    return unless placed?

    rotate(-1)
  end

  def right
    return unless placed?

    rotate(1)
  end

  def move
    return unless placed?

    @x, @y = next_position
  end

  def next_position
    return unless placed?

    dx, dy = MOVEMENTS[direction]
    [x + dx, y + dy]
  end

  def report
    return unless placed?

    "#{x},#{y},#{direction}"
  end

  def placed?
    !(x.nil? || y.nil? || direction.nil?)
  end

  private

  def rotate(step)
    @direction = DIRECTIONS[(DIRECTIONS.index(direction) + step) % DIRECTIONS.size]
  end
end
