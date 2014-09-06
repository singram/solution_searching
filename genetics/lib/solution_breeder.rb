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
      pp @population.scores[0..5]
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

    while new_pop.size < @population_size
      if Random.rand() < @prob_new
        new_pop << AlgorithmFactory.generate(algorithm_input_count)
      else
        cross_breed = crossover(@population.biased_random_algorithm, @population.biased_random_algorithm, @breeding_rate)
        new_pop <<  mutate(cross_breed, @mutation_rate)
      end
    end
    Population.new(new_pop, SolutionBreeder.method(:fitness_score), @data_set)
  end

  def mutate(a, mutation_chance = 0.1)
    if Random.rand() < mutation_chance
      AlgorithmFactory.generate(algorithm_input_count)
    else
      node = a.clone
      if node.is_a?(Node)
        node.function_params = a.function_params.map{|child| mutate(child) }
      end
      node
    end
  end

  def crossover(a1, a2, swap_chance = 0.7, top=true)
    if Random.rand() < swap_chance && !top
      result = a2.deep_copy
    else
      result = a1.deep_copy
      if result.is_a?(Node) && a2.is_a?(Node)
        result.function_params = a1.function_params.map{|c1| crossover(c1, a2.function_params.sample, swap_chance, false) }
      end
    end
    result
  end

  def self.fitness_score(data_set, algorithm)
    data_set.map do| params, value|
      (algorithm.evaluate(params) - value).abs
    end.inject(&:+)
  end

end
