
module Roomba
  class Simulation
    include Roomba

    def initialize(filepath)
      @filepath = filepath
      @setup = {}
      @hoover = nil
      @room = nil
    end

    def run_simulation
      file_lines = load_file(@filepath)

      process_lines file_lines

      create_objects
      run_hoover_commands
      print_result
    end

    def process_lines(lines)
      dimensions = lines.first
      position = lines[1]
      commands = lines.last
      @setup = { room_dimensions: dimensions.map(&:to_i),
                 hoover_position: position.map(&:to_i),
                 hoover_commands: commands,
                 list_of_dirt: lines - [dimensions] - [position] - [commands] }
    end

    def create_objects
      @room = Room.new(@setup[:room_dimensions], @setup[:list_of_dirt])
      @hoover = Hoover.new(@setup[:hoover_position],
                           @setup[:hoover_commands],
                           @room)
    end

    def run_hoover_commands
      @hoover.run_commands
    end

    def print_result
      final_position = @hoover.position
      puts "#{final_position[:x]} #{final_position[:y]}"
      puts @hoover.nr_cleaned_patches.to_s
    end
  end
end
