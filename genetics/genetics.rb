require './lib/algorithm_factory.rb'
require './lib/data_set_factory.rb'
require './lib/functions.rb'
require './lib/nodes.rb'
require './lib/population.rb'
require './lib/solution_breeder.rb'
require 'pp'

function = lambda { |a,b| a*b+3 }

data_set_factory = DataSetFactory.new(function)
data_set = data_set_factory.generate(200, 100, 100)

s = SolutionBreeder.new(data_set, 100)
s.breed
