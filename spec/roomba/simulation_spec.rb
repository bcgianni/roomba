require 'spec_helper'

describe Roomba::Simulation do
  let(:simulation) { Roomba::Simulation.new('spec/fixtures/files/input.txt') }

  context '.run_simulation' do
    it 'outputs expected result for input.txt' do
      expect { simulation.run_simulation }.to output("1 3\n1\n").to_stdout
    end
  end

  # let(:dummy_class) { Class.new { include Roomba } }
  #
  # it 'does something useful' do
  #   expect { dummy_class.new.execute_hoover }.to output('my message').to_stdout
  #   expect(false).to eq(true)
  # end
end
