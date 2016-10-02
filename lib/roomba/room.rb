module Roomba
  class Room
    attr_accessor :list_of_dirt

    def initialize(dimension, list_of_dirt)
      @dimension = { x: dimension[0] - 1, y: dimension[1] - 1 }
      @list_of_dirt = list_of_dirt
    end

    def upper_y_limit
      @dimension[:y]
    end

    def upper_x_limit
      @dimension[:x]
    end

    def lower_y_limit
      0
    end

    def lower_x_limit
      0
    end
  end
end
