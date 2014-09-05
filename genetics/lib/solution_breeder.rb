class SolutionBreeder

  attr_accessor :population

  def initialize(data_set, population_size, max_gen=500, mutation_rate=0.1, breeding_rate=0.4, prob_new=0.05)
    @data_set = data_set
    @population_size = population_size
    @max_gen = max_gen
    @mutation_rate = mutation_rate
    @breeding_rate = breeding_rate
    @prob_new = prob_new
    @stats = {}
    @population = random_population
  end

  def algorithm_input_count
    @data_set.keys.first.size
  end

  def random_population
    new_population = Array.new(@population_size){|i| AlgorithmFactory.generate(algorithm_input_count)}
    Population.new(new_population, SolutionBreeder.method(:fitness_score), @data_set)
  end

  def breed
    gen = 0
    while gen < @max_gen && !population.solution_found?
      @population = breed_new_population
      gen += 1
    end
    evaluate_breeding_cycle(gen)
  end

  def evaluate_breeding_cycle(generations)
    if population.solution_found?
      puts "Solution found in #{generations} generations"
    else
      puts "No solution found after #{generations} generations"
      puts "Closest score was #{population.best_score}"
    end
    puts population.best_algorithm
  end

  def breed_new_population
    new_pop = []
    new_pop << population.best_algorithm
    new_pop << population.n_best_algorithm(1)
    new_pop += Array.new(@population_size-2){|i| AlgorithmFactory.generate(algorithm_input_count)}
    Population.new(new_pop, SolutionBreeder.method(:fitness_score), @data_set)
  end

  def self.fitness_score(data_set, algorithm)
    data_set.map do| params, value|
      (algorithm.evaluate(params) - value).abs
    end.inject(&:+)
  end

end
