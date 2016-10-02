require 'spec_helper'

describe Roomba::Hoover do
  let(:initial_position) { [1, 2] }
  let(:expected_ini_position) { { x: 1, y: 2 } }
  let(:set_of_commands) { ['NNEESSWW'] }
  let(:dimension) { [3, 3] }
  let(:list_of_dirt) { [%w(1 2), %w(2 1)] }
  let(:room) { Roomba::Room.new(dimension, list_of_dirt) }
  let(:hoover) { Roomba::Hoover.new(initial_position, set_of_commands, room) }

  context '.initialize' do
    it 'creates hoover object correctly' do
      expect(hoover.position).to eq expected_ini_position
      expect(hoover.nr_cleaned_patches).to eq 0
      expect(hoover.instance_variable_get(:@room)).to eq room
    end
  end

  context '.run_commands' do
    let(:expected_final_position) { { x: 0, y: 0 } }
    let(:expected_cleaned_patches) { 2 }

    it 'calls each go method 2 times' do
      expect(hoover).to receive(:go_north).exactly(2).times
      expect(hoover).to receive(:go_east).exactly(2).times
      expect(hoover).to receive(:go_south).exactly(2).times
      expect(hoover).to receive(:go_west).exactly(2).times
      hoover.run_commands
    end

    it 'calls clean method 9 times' do
      expect(hoover).to receive(:clean).exactly(9).times
      hoover.run_commands
    end

    it 'goes to expected final position' do
      hoover.run_commands
      expect(hoover.position).to eq expected_final_position
    end

    it 'cleans expected nr of patches' do
      hoover.run_commands
      expect(hoover.nr_cleaned_patches).to eq expected_cleaned_patches
    end
  end
  context '.go_north' do
    let(:y_limit) { [1, 2] }
    let(:hoover_at_limit) { Roomba::Hoover.new(y_limit, set_of_commands, room) }
    let(:not_y_limit) { [1, 1] }
    let(:hoover_not_at_limit) do
      Roomba::Hoover.new(not_y_limit,
                         set_of_commands,
                         room)
    end

    it 'calls clean method' do
      expect(hoover).to receive(:clean).once
      hoover.go_north
    end

    context 'at upper y limit' do
      it 'does not add one on y position' do
        hoover.go_north
        final_y_position = hoover.instance_variable_get(:@position)[:y]
        expect(final_y_position).to eq y_limit[1]
      end
    end

    context 'not at upper y limit' do
      it 'adds one on y position' do
        hoover.go_north
        final_y_position = hoover.instance_variable_get(:@position)[:y]
        expect(final_y_position).to eq not_y_limit[1] + 1
      end
    end
  end

  context '.go_east' do
    let(:x_limit) { [2, 2] }
    let(:hoover_at_limit) { Roomba::Hoover.new(x_limit, set_of_commands, room) }
    let(:not_x_limit) { [1, 1] }
    let(:hoover_not_at_limit) do
      Roomba::Hoover.new(not_x_limit,
                         set_of_commands, room)
    end

    it 'calls clean method' do
      expect(hoover).to receive(:clean).once
      hoover.go_east
    end

    context 'at upper x limit' do
      it 'does not add one on x position' do
        hoover_at_limit.go_east
        final_x_position = hoover_at_limit.instance_variable_get(:@position)[:x]
        expect(final_x_position).to eq x_limit[0]
      end
    end

    context 'not at upper x limit' do
      it 'adds one on x position' do
        hoover_not_at_limit.go_east
        x_position = hoover_not_at_limit.instance_variable_get(:@position)[:x]
        expect(x_position).to eq not_x_limit[0] + 1
      end
    end
  end

  context '.go_south' do
    let(:y_limit) { [2, 0] }
    let(:hoover_at_limit) { Roomba::Hoover.new(y_limit, set_of_commands, room) }
    let(:not_y_limit) { [1, 1] }
    let(:hoover_not_at_limit) do
      Roomba::Hoover.new(not_y_limit, set_of_commands,
                         room)
    end

    it 'calls clean method' do
      expect(hoover).to receive(:clean).once
      hoover.go_south
    end

    context 'at lower y limit' do
      it 'does not subtract one on y position' do
        hoover_at_limit.go_south
        final_y_position = hoover_at_limit.instance_variable_get(:@position)[:y]
        expect(final_y_position).to eq y_limit[1]
      end
    end

    context 'not at lower y limit' do
      it 'subtracts one on y position' do
        hoover_not_at_limit.go_south
        y_position = hoover_not_at_limit.instance_variable_get(:@position)[:y]
        expect(y_position).to eq not_y_limit[1] - 1
      end
    end
  end

  context '.go_west' do
    let(:x_limit) { [0, 0] }
    let(:hoover_at_limit) { Roomba::Hoover.new(x_limit, set_of_commands, room) }
    let(:not_x_limit) { [1, 1] }
    let(:hoover_not_at_limit) do
      Roomba::Hoover.new(not_x_limit,
                         set_of_commands, room)
    end

    it 'calls clean method' do
      expect(hoover).to receive(:clean).once
      hoover.go_west
    end

    context 'at lower x limit' do
      it 'does not subtract one on x position' do
        hoover_at_limit.go_west
        x_position = hoover_at_limit.instance_variable_get(:@position)[:x]
        expect(x_position).to eq x_limit[0]
      end
    end

    context 'not at lower x limit' do
      it 'subtracts one on x position' do
        hoover_not_at_limit.go_west
        x_position = hoover_not_at_limit.instance_variable_get(:@position)[:x]
        expect(x_position).to eq not_x_limit[1] - 1
      end
    end
  end

  context '.hoover_at_upper_y_limit?' do
    context 'when at upper y limit' do
      let(:y_limit) { [2, 2] }
      let(:hoover_at_limit) do
        Roomba::Hoover.new(y_limit,
                           set_of_commands, room)
      end

      it 'returns true' do
        expect(hoover_at_limit.at_upper_y_limit?).to eq true
      end
    end
    context 'when not at upper y limit' do
      let(:not_y_limit) { [1, 1] }
      let(:hoover_not_at_limit) do
        Roomba::Hoover.new(not_y_limit,
                           set_of_commands, room)
      end
      it 'returns false' do
        expect(hoover_not_at_limit.at_upper_y_limit?).to eq false
      end
    end
  end

  context '.hoover_at_lower_y_limit?' do
    context 'when at lower y limit' do
      let(:y_limit) { [2, 0] }
      let(:hoover_at_limit) do
        Roomba::Hoover.new(y_limit,
                           set_of_commands, room)
      end

      it 'returns true' do
        expect(hoover_at_limit.at_lower_y_limit?).to eq true
      end
    end
    context 'when not at lower y limit' do
      let(:not_y_limit) { [1, 1] }
      let(:hoover_not_at_limit) do
        Roomba::Hoover.new(not_y_limit,
                           set_of_commands, room)
      end
      it 'returns false' do
        expect(hoover_not_at_limit.at_lower_y_limit?).to eq false
      end
    end
  end

  context '.hoover_at_lower_x_limit?' do
    context 'when at lower x limit' do
      let(:x_limit) { [0, 0] }
      let(:hoover_at_limit) do
        Roomba::Hoover.new(x_limit,
                           set_of_commands, room)
      end

      it 'returns true' do
        expect(hoover_at_limit.at_lower_x_limit?).to eq true
      end
    end
    context 'when not at lower x limit' do
      let(:not_x_limit) { [1, 1] }
      let(:hoover_not_at_limit) do
        Roomba::Hoover.new(not_x_limit,
                           set_of_commands, room)
      end
      it 'returns false' do
        expect(hoover_not_at_limit.at_lower_x_limit?).to eq false
      end
    end
  end

  context '.hoover_at_upper_x_limit?' do
    context 'when at upper x limit' do
      let(:x_limit) { [2, 0] }
      let(:hoover_at_limit) do
        Roomba::Hoover.new(x_limit,
                           set_of_commands, room)
      end

      it 'returns true' do
        expect(hoover_at_limit.at_upper_x_limit?).to eq true
      end
    end
    context 'when not at upper x limit' do
      let(:not_x_limit) { [1, 1] }
      let(:hoover_not_at_limit) do
        Roomba::Hoover.new(not_x_limit,
                           set_of_commands, room)
      end
      it 'returns false' do
        expect(hoover_not_at_limit.at_lower_x_limit?).to eq false
      end
    end
  end

  context '.clean' do
    context 'at patch position' do
      let(:to_clean_position) { [1, 2] }
      let(:hoover) do
        Roomba::Hoover.new(to_clean_position,
                           set_of_commands, room)
      end
      let(:cleaned_list) { [%w(2 1)] }

      it 'removes patch position' do
        hoover.clean
        expect(room.list_of_dirt).to eq cleaned_list
      end

      it 'calls .count_cleaned_patch' do
        expect(hoover).to receive(:count_cleaned_patch).once
        hoover.clean
      end
    end

    context 'not at patch position' do
      let(:not_to_clean_position) { [2, 2] }
      let(:hoover) do
        Roomba::Hoover.new(not_to_clean_position,
                           set_of_commands, room)
      end
      it 'does not remove patch position' do
        hoover.clean
        expect(room.list_of_dirt).to eq list_of_dirt
      end

      it 'does not call .count_cleaned_patch' do
        expect(hoover).to_not receive(:count_cleaned_patch)
        hoover.clean
      end
    end
  end

  context '.count_cleaned_patch' do
    it 'adds one to nr_cleaned_patches' do
      hoover.count_cleaned_patch
      expect(hoover.nr_cleaned_patches).to eq 1
    end
  end
end
