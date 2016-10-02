require 'spec_helper'

describe Roomba do
  let(:dummy_class) { Class.new { include Roomba } }
  let(:valid_filepath) { 'spec/fixtures/files/input.txt' }
  let(:expected_array) do
    [%w(5 5), %w(1 2), %w(1 0),
     %w(2 2), %w(2 3), ['NNESEESWNWW']]
  end

  context '.load_file' do
    context 'when providing a valid input file' do
      it 'reads correctly the input file' do
        expect(dummy_class.new.load_file(valid_filepath)).to eq expected_array
      end
    end
  end
end
