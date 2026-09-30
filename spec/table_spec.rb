require_relative '../lib/table'

RSpec.describe Table do
  subject(:table) { described_class.new }

  it 'has a default width of 5' do
    expect(table.width).to eq 5
  end

  it 'has a default height of 5' do
    expect(table.height).to eq 5
  end

  describe "#valid_position?" do
    it 'returns true for positions on the table' do
      expect(table.valid_position?(0,0)).to eq true
      expect(table.valid_position?(4,4)).to eq true
      expect(table.valid_position?(2,3)).to eq true
    end

    it 'returns false for positions off each edge' do
      expect(table.valid_position?(5,0)).to eq false
      expect(table.valid_position?(0,5)).to eq false
      expect(table.valid_position?(-1,0)).to eq false
      expect(table.valid_position?(0,-1)).to eq false
    end
  end

  it 'supports a custom size' do
    custom_table = Table.new(width: 10, height: 10)
    expect(custom_table.valid_position?(9,9)).to eq true
    expect(custom_table.valid_position?(10,8)).to eq false
    expect(custom_table.valid_position?(1,10)).to eq false
  end
end
