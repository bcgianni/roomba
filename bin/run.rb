require "bundler/setup"
require "roomba"

filepath = ARGV[0]

simulation = Roomba::Simulation.new(filepath)
simulation.run_simulation
