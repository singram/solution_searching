class Population

  attr_accessor :population, :data_set

  def initialize(pop, fitness_function, data_set)
    @population = pop
    @fitness_score_function = fitness_function
    @data_set = data_set
  end

  def solution_found?
    best_score == 0
  end

  def solution
    best_algorithm if solution_found?
  end

  def best_score
    ranked_list[0][0]
  end

  def best_algorithm
    n_best_algorithm(0)
  end

  def n_best_algorithm(n)
    ranked_list[n][1]
  end

  def ranked_list
    @ranked_list ||= @population.map{|a| [@fitness_score_function.call(@data_set, a), a] }.sort{|a,b| a[0] <=> b[0]}
  end

  def rank_total
    @rank_total ||= @population.map{|a| @fitness_score_function.call(@data_set, a) }.inject(&:+)
  end

  def scores
    @scores ||= ranked_list.map{|r| r[0] }
  end

  WEIGHTS = [0.50, 0.30, 0.15, 0.05]
  def biased_random_algorithm
    r = Random.rand
    cumulative_weight = 0
    WEIGHTS.each_with_index do |weight, i|
      cumulative_weight += weight
      if r < cumulative_weight
        idx = (i+r)/WEIGHTS.size
        idx *= @population.size
        return ranked_list[idx.to_i][1]
      end
    end
  end

end
