require_relative '../lib/simulator'

RSpec.describe Simulator do
  subject(:simulator) { described_class.new }

  # Runs each command through the simulator and returns only the REPORT output
  def run(commands)
    commands.map { |line| simulator.execute(line) }.compact
  end

  describe "example scenarios from the brief" do
    {
      "scenario_a.txt" => ["0,1,NORTH"],
      "scenario_b.txt" => ["0,0,WEST"],
      "scenario_c.txt" => ["3,3,NORTH"]
    }.each do |file, expected|
      it "produces the expected output for #{file}" do
        lines = File.readlines(File.join(__dir__, "fixtures", file))
        expect(run(lines)).to eq expected
      end
    end
  end

  describe "#execute" do
    it "returns nil for commands other than REPORT" do
      expect(simulator.execute("PLACE 0,0,NORTH")).to be_nil
      expect(simulator.execute("MOVE")).to be_nil
      expect(simulator.execute("LEFT")).to be_nil
      expect(simulator.execute("RIGHT")).to be_nil
    end

    it "returns the robot's position for REPORT" do
      simulator.execute("PLACE 2,3,EAST")
      expect(simulator.execute("REPORT")).to eq "2,3,EAST"
    end
  end

  describe "before the first valid PLACE" do
    it "ignores all commands" do
      expect(run(["MOVE", "LEFT", "RIGHT", "REPORT"])).to eq []
    end

    it "starts responding once the robot is placed" do
      expect(run(["MOVE", "REPORT", "PLACE 1,1,NORTH", "REPORT"])).to eq ["1,1,NORTH"]
    end
  end

  describe "PLACE" do
    it "ignores a PLACE off the table when the robot is not yet placed" do
      expect(run(["PLACE 5,5,NORTH", "REPORT"])).to eq []
    end

    it "ignores a PLACE off the table and keeps the current position" do
      expect(run(["PLACE 1,1,NORTH", "PLACE 7,7,SOUTH", "REPORT"])).to eq ["1,1,NORTH"]
    end

    it "moves the robot with a second valid PLACE" do
      expect(run(["PLACE 1,1,NORTH", "PLACE 3,3,WEST", "REPORT"])).to eq ["3,3,WEST"]
    end
  end

  describe "MOVE" do
    it "ignores a move off the north edge" do
      expect(run(["PLACE 0,4,NORTH", "MOVE", "REPORT"])).to eq ["0,4,NORTH"]
    end

    it "ignores a move off the south edge" do
      expect(run(["PLACE 0,0,SOUTH", "MOVE", "REPORT"])).to eq ["0,0,SOUTH"]
    end

    it "ignores a move off the east edge" do
      expect(run(["PLACE 4,0,EAST", "MOVE", "REPORT"])).to eq ["4,0,EAST"]
    end

    it "ignores a move off the west edge" do
      expect(run(["PLACE 0,0,WEST", "MOVE", "REPORT"])).to eq ["0,0,WEST"]
    end

    it "still accepts valid commands after an ignored move" do
      expect(run(["PLACE 0,4,NORTH", "MOVE", "RIGHT", "MOVE", "REPORT"])).to eq ["1,4,EAST"]
    end
  end

  describe "LEFT and RIGHT" do
    it "turns a full circle back to the starting direction" do
      expect(run(["PLACE 2,2,NORTH", "RIGHT", "RIGHT", "RIGHT", "RIGHT", "REPORT"])).to eq ["2,2,NORTH"]
    end

    it "changes direction without changing position" do
      expect(run(["PLACE 2,2,NORTH", "LEFT", "REPORT"])).to eq ["2,2,WEST"]
    end
  end

  describe "invalid input" do
    it "skips invalid lines and carries on with valid ones" do
      commands = ["PLACE 1,1,NORTH", "JUMP", "MOVE 2", "", "PLACE 1,2", "MOVE", "REPORT"]
      expect(run(commands)).to eq ["1,2,NORTH"]
    end
  end

  describe "multiple REPORTs" do
    it "outputs a line for each REPORT" do
      expect(run(["PLACE 0,0,NORTH", "REPORT", "MOVE", "REPORT"])).to eq ["0,0,NORTH", "0,1,NORTH"]
    end
  end
end
