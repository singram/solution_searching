class DataSetFactory

  attr_reader :function

  def initialize(function)
    @function = function
  end

  def generate(set_size, *param_maxima)
    fail "Generation parameters do not match expected count of lambda" if @function.parameters.size != param_maxima.size
    data_set = {}
    set_size.times do |i|
      params = param_maxima.map{ |m| Random.rand(m) }
      data_set[params] = @function.call(*params)
    end
    data_set
  end

end
