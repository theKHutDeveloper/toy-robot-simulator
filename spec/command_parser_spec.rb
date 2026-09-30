require_relative '../lib/command_parser'

RSpec.describe CommandParser do
  subject(:command_parser) { described_class.new('PLACE 1,2,NORTH') }

  describe "#parse" do
    it "returns command in uppercase" do
      lower_case_command = 'place 2,2,west'
      expect(described_class.new(lower_case_command).parse).to eq({ command: 'PLACE', x:2, y:2, direction: 'WEST' })
    end

    it "returns nil if command is blank" do
      expect(described_class.new('').parse).to eq nil
    end

    it "returns nil if command PLACE doesn't have any arguments" do
      expect(described_class.new('PLACE').parse).to eq nil
    end

    it "returns nil if command PLACE doesn't have 3 arguments" do
      expect(described_class.new('PLACE 1,2').parse).to eq nil
    end

    it "returns nil if command PLACE doesn't contain integer positions" do
      expect(described_class.new('PLACE a,b,NORTH').parse).to eq nil
    end

    it "returns nil if command PLACE doesn't contain a valid direction" do
      expect(described_class.new('PLACE 1,2,UP').parse).to eq nil
    end

    it "returns nil if command PLACE has invalid arguments" do
      expect(described_class.new('PLACE 1,,NORTH').parse).to eq nil
    end

    it "returns nil if command PLACE has extra spacing" do
      expect(described_class.new('PLACE 1, 2, NORTH').parse).to eq nil
    end

    it "returns nil if command is invalid" do
      expect(described_class.new('JUMP').parse).to eq nil
    end

    it "returns a valid PLACE command into a structured object" do
      expect(command_parser.parse).to eq( { command: 'PLACE', x:1, y:2, direction: 'NORTH' } )
    end

    it "returns a valid PLACE command with integer positions outside of default table size" do
      command_parser = described_class.new('PLACE 7,7,NORTH')
      expect(command_parser.parse).to eq( { command: 'PLACE', x:7, y:7, direction: 'NORTH' } )
    end

    it "returns a valid MOVE command into a structured object" do
      command_parser = described_class.new('MOVE')
      expect(command_parser.parse).to eq( { command: 'MOVE' } )
    end

    it "returns a valid LEFT command into a structured object" do
      command_parser = described_class.new('LEFT')
      expect(command_parser.parse).to eq( { command: 'LEFT' } )
    end

    it "returns a valid RIGHT command into a structured object" do
      command_parser = described_class.new('RIGHT')
      expect(command_parser.parse).to eq( { command: 'RIGHT' } )
    end

    it "returns a valid REPORT command into a structured object" do
      command_parser = described_class.new('REPORT')
      expect(command_parser.parse).to eq( { command: 'REPORT' } )
    end

    it "ignores commands with additional arguments unless command is PLACE" do
      command_parser = described_class.new('MOVE 1,2,NORTH')
      expect(command_parser.parse).to eq nil
    end

    it 'ignores PLACE commands with additional arguments' do
      command_parser = described_class.new('PLACE 1,2,NORTH,MOVE')
      expect(command_parser.parse).to eq nil
    end
  end
end
