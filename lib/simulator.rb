require_relative 'table'
require_relative 'robot'
require_relative 'command_parser'

class Simulator
  def initialize
    @table = Table.new
    @robot = Robot.new
  end

  def execute(line)
    command = CommandParser.new(line).parse
    return unless command

    case command[:command]
    when "PLACE"
      x = command[:x]
      y = command[:y]
      if @table.valid_position?(x, y)
        @robot.place(**command.except(:command))
      end

    when "MOVE"
      return unless @robot.placed?

      x,y = @robot.next_position
      @robot.move if @table.valid_position?(x, y)

    when "LEFT"
      @robot.left
    when "RIGHT"
      @robot.right
    when "REPORT"
      return @robot.report
    end

    nil
  end
end
