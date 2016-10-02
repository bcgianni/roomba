require "bundler/setup"
require "roomba"

filepath = ARGV[0]

puts filepath

simulation = Roomba::Simulation.new(filepath)
simulation.run_simulation
