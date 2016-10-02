require 'spec_helper'

describe Roomba::Room do
  let(:dimension) { [3, 3] }
  let(:expected_dimension) { { x: 2, y: 2 } }
  let(:list_of_dirt) { [%w(1 2), ['2,1']] }
  let(:room) { Roomba::Room.new(dimension, list_of_dirt) }

  context '.initialize' do
    it 'creates room object correctly' do
      dimension = room.instance_variable_get(:@dimension)
      expect(dimension).to eq expected_dimension
      expect(room.list_of_dirt).to eq list_of_dirt
    end
  end

  context '.upper_x_limit' do
    it 'returns x dimension' do
      expect(room.upper_x_limit).to eq expected_dimension[:x]
    end
  end

  context '.upper_y_limit' do
    it 'returns y dimension' do
      expect(room.upper_y_limit).to eq expected_dimension[:y]
    end
  end

  context '.lower_x_limit' do
    it 'returns 0' do
      expect(room.lower_x_limit).to eq(0)
    end
  end

  context '.lower_y_limit' do
    it 'returns 0' do
      expect(room.lower_y_limit).to eq(0)
    end
  end
end
