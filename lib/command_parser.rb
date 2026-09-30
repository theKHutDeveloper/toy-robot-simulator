require_relative 'robot'

class CommandParser
  DIRECTIONS = Robot::DIRECTIONS

  def initialize(command)
    @command = command.to_s.upcase
  end

  def parse
    name, args, *extra = @command.to_s.split
    return unless extra.empty?

    case name
    when "PLACE"
      parse_place(args)
    when "MOVE", "LEFT", "RIGHT", "REPORT"
      { command: name } if args.nil?
    end
  end

  private

  def parse_place(args)
    return unless args

    parts = args.split(",", -1)
    return unless parts.size == 3

    x, y, direction = parts

    return unless DIRECTIONS.include?(direction)

    x = Integer(x, exception: false)
    y = Integer(y, exception: false)

    return if x.nil? || y.nil?

    { command: 'PLACE', x: x, y: y, direction: direction }
  end
end
