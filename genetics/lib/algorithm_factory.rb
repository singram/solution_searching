class AlgorithmFactory

  def self.generate(param_count, maxdepth=4, func_prob=0.5, param_prob=0.6)
    if Random.rand() < func_prob and maxdepth > 0
      f = Function.random
      children = Array.new(f.parameters_needed){ |i| self.generate(param_count, maxdepth-1, func_prob, param_prob) }
      Node.new(f, *children)
    elsif Random.rand() < param_prob
      ParamNode.new(Random.rand(param_count))
    else
      ConstNode.new(Random.rand(10))
    end
  end

end
