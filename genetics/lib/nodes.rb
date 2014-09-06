class Node
  attr_accessor :function, :function_params

  def initialize(func, *params)
    @function = func
    @function_params = params
  end

  def evaluate(inputs)
    @function.call(*@function_params.map{ |f| f.evaluate(inputs) })
  end

  def to_s(indent = 0)
    (' '*indent + function.name + "\n") + function_params.map{|f| f.to_s(indent+1)}.join("\n")
  end

  def deep_copy
    copy = self.clone
    copy.function_params = self.function_params.map{|f| f.deep_copy}
    copy
  end

end

class ConstNode

  def initialize(c)
    @c = c
  end

  def evaluate(inputs)
    @c
  end

  def to_s(indent = 0)
    ' '*indent + "#{@c}"
  end

  def deep_copy
    self.clone
  end

end

class ParamNode

  def initialize(index)
    @index = index
  end

  def evaluate(inputs)
    inputs[@index%inputs.size]
  end

  def to_s(indent = 0)
    ' '*indent + "p(#{@index})"
  end

  def deep_copy
    self.clone
  end

end
