module Roomba
  class Hoover
    attr_reader :position, :nr_cleaned_patches

    def initialize(hoover_position, set_of_commands = '', room = nil)
      @position = { x: hoover_position[0], y: hoover_position[1] }
      @set_of_commands = set_of_commands
      @nr_cleaned_patches = 0
      @room = room
    end

    def run_commands
      clean
      @set_of_commands[0].split("").each do |command|
        case command
        when 'N' then go_north
        when 'E' then go_east
        when 'S' then go_south
        when 'W' then go_west
        end
      end
    end

    def go_north
      @position[:y] += 1 unless at_upper_y_limit?
      clean
    end

    def go_south
      @position[:y] -= 1 unless at_lower_y_limit?
      clean
    end

    def go_east
      @position[:x] += 1 unless at_upper_x_limit?
      clean
    end

    def go_west
      @position[:x] -= 1 unless at_lower_x_limit?
      clean
    end

    def at_upper_y_limit?
      @position[:y] == @room.upper_y_limit
    end

    def at_lower_y_limit?
      @position[:y] == @room.lower_y_limit
    end

    def at_upper_x_limit?
      @position[:x] == @room.upper_x_limit
    end

    def at_lower_x_limit?
      @position[:x] == @room.lower_x_limit
    end

    def clean
      current_position = [@position[:x], @position[:y]].map(&:to_s)
      list_of_dirt = @room.list_of_dirt
      if list_of_dirt.include?(current_position)
        list_of_dirt -= [current_position]
        count_cleaned_patch
      end
      @room.list_of_dirt = list_of_dirt
    end

    def count_cleaned_patch
      @nr_cleaned_patches += 1
    end
  end
end
