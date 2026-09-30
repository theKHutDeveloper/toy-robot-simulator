require_relative '../lib/robot'

RSpec.describe Robot do
  subject(:robot) { described_class.new }

  describe "#placed?" do
    it "returns false if robot is not placed" do
      expect(robot.placed?).to eq false
    end

    it "returns true if robot is placed" do
      robot.place(x:1, y:2, direction: "NORTH")
      expect(robot.placed?).to eq true
    end
  end

  describe "#place" do
    it 'returns nil if direction is invalid' do
      expect(robot.place(x:1, y:2, direction: "DOWN")).to eq nil
    end

    it 'places position and direction' do
      robot.place(x:1, y:2, direction: "NORTH")
      expect(robot.x).to eq 1
      expect(robot.y).to eq 2
      expect(robot.direction).to eq 'NORTH'
    end

    it 'overrides position and direction' do
      robot.place(x:1, y:2, direction: "NORTH")
      robot.place(x:3, y:4, direction: "EAST")
      expect(robot.x).to eq 3
      expect(robot.y).to eq 4
      expect(robot.direction).to eq 'EAST'
    end
  end

  describe "#left" do
    it "does nothing if robot is not placed" do
      robot.left
      expect(robot.direction).to eq nil
    end

    it "it rotates to the last direction when at the first" do
      robot.place(x:1, y:2, direction: "NORTH")
      robot.left
      expect(robot.direction).to eq 'WEST'
    end

    it "rotates left" do
      robot.place(x:1, y:2, direction: "WEST")
      robot.left
      expect(robot.direction).to eq 'SOUTH'
    end
  end

  describe "#right" do
    it "does nothing if robot is not placed" do
      robot.right
      expect(robot.direction).to eq nil
    end

    it "it rotates to the first direction when at the last" do
      robot.place(x:1, y:2, direction: "WEST")
      robot.right
      expect(robot.direction).to eq 'NORTH'
    end

    it "rotates right" do
      robot.place(x:1, y:2, direction: "EAST")
      robot.right
      expect(robot.direction).to eq 'SOUTH'
    end
  end

  describe "#move" do
    it "does nothing if robot is not placed" do
      robot.move
      expect(robot.x).to eq nil
      expect(robot.y).to eq nil
    end

    context "when robot is placed" do
      it "moves north" do
        robot.place(x:1, y:2, direction: "NORTH")
        robot.move
        expect(robot.x).to eq 1
        expect(robot.y).to eq 3
      end

      it "moves east" do
        robot.place(x:1, y:2, direction: "EAST")
        robot.move
        expect(robot.x).to eq 2
        expect(robot.y).to eq 2
      end

      it "moves south" do
        robot.place(x:1, y:2, direction: "SOUTH")
        robot.move
        expect(robot.x).to eq 1
        expect(robot.y).to eq 1
      end

      it "moves west" do
        robot.place(x:1, y:2, direction: "WEST")
        robot.move
        expect(robot.x).to eq 0
        expect(robot.y).to eq 2
      end
    end
  end

  describe "#next_position" do
    it "does nothing if robot is not placed" do
      expect(robot.next_position).to eq nil
    end

    it "returns the next position" do
      robot.place(x:1, y:2, direction: "NORTH")
      expect(robot.next_position).to eq [1,3]
    end

    it "does not change the robot's position" do
      robot.place(x: 1, y: 2, direction: "NORTH")
      robot.next_position
      expect(robot.report).to eq "1,2,NORTH"
    end
  end

  describe "#report" do
    it "returns nil if robot is not placed" do
      expect(robot.report).to eq nil
    end

    context "when robot is placed" do
      it "reports it's position" do
        robot.place(x:1, y:2, direction: "NORTH")
        expect(robot.report).to eq '1,2,NORTH'
      end
    end
  end
end
