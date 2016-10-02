require 'spec_helper'

describe Roomba::Simulation do
  let(:valid_filepath) { 'spec/fixtures/files/input.txt' }
  let(:simulation) { Roomba::Simulation.new(valid_filepath) }
  let(:valid_lines) { simulation.load_file(valid_filepath) }
  let(:expected_setup_hash) do
    { room_dimensions: [5, 5],
      hoover_position: [1, 2],
      hoover_commands: ['NNESEESWNWW'],
      list_of_dirt: [%w(1 0), %w(2 2), %w(2 3)] }
  end
  let(:expected_array) do
    [%w(5 5), %w(1 2), %w(1 0),
     %w(2 2), %w(2 3), ['NNESEESWNWW']]
  end
  let(:expected_room) do
    Roomba::Room.new(expected_setup_hash[:room_dimensions],
                     expected_setup_hash[:list_of_dirt])
  end
  let(:expected_hoover) do
    Roomba::Hoover.new(expected_setup_hash[:hoover_position],
                     expected_setup_hash[:hoover_commands],
                     room)
  end
  let(:expected_room_dimension) { {x:4, y:4} }
  let(:expected_list_of_dirt) { expected_setup_hash[:list_of_dirt] }
  let(:expected_hoover_position) { {x:1, y:2} }

  context '.run_simulation' do
    context 'when providing a valid input file' do
      it 'outputs expected result for input.txt' do
        expect { simulation.run_simulation }.to output("1 3\n1\n").to_stdout
      end
    end
  end

  context '.load_file' do
    context 'when providing a valid input file' do
      it 'reads correctly the input file' do
        expect(simulation.load_file(valid_filepath)).to eq expected_array
      end
    end
  end

  context '.process_lines' do
    context 'when providing a valid input file' do

      it 'correctly structures the setup hash' do
        simulation.process_lines(valid_lines)
        expect(simulation.instance_variable_get(:@setup)).to eq expected_setup_hash
      end
    end
  end

  context '.create_objects' do
    context 'with valid setup' do

      it 'creates room object correctly' do
        simulation.process_lines(valid_lines)
        simulation.create_objects
        room = simulation.instance_variable_get(:@room)
        room_dimension = room.instance_variable_get(:@dimension)
        list_of_dirt = room.list_of_dirt
        expect(room_dimension).to eq expected_room_dimension
        expect(list_of_dirt).to eq expected_list_of_dirt
      end

      it 'creates hoover object correctly' do
        simulation.process_lines(valid_lines)
        simulation.create_objects
        hoover = simulation.instance_variable_get(:@hoover)
        position = hoover.instance_variable_get(:@position)
        nr_cleaned_patches = hoover.nr_cleaned_patches
        expect(position).to eq expected_hoover_position
        expect(nr_cleaned_patches).to eq 0
      end
    end

    context '.run_hoover_commands', :go do
      context 'with correct objects setup' do
          it 'calls .run_commands on object hoover' do
            simulation.process_lines(valid_lines)
            simulation.create_objects
            hoover = simulation.instance_variable_get(:@hoover)
            expect(hoover).to receive(:run_commands)
            simulation.run_hoover_commands
          end
      end
    end

    context '.print_result', :go do
      context 'with valid hoover' do
        it 'prints hoover position' do
          simulation.process_lines(valid_lines)
          simulation.create_objects
          expect { simulation.print_result }.to output("1 2\n0\n").to_stdout
        end
      end
    end

  end

  # let(:dummy_class) { Class.new { include Roomba } }
  #
  # it 'does something useful' do
  #   expect { dummy_class.new.execute_hoover }.to output('my message').to_stdout
  #   expect(false).to eq(true)
  # end
end
