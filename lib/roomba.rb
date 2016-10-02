module Roomba
  # Your code goes here...
  autoload :Room,   'roomba/room'
  autoload :Hoover, 'roomba/hoover'
  autoload :Simulation, 'roomba/simulation'

  def load_file(filepath)
    file_lines = []
    File.readlines(filepath).map do |line|
      file_lines << line.split
    end
    file_lines
  end
end
