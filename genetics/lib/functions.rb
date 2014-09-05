require 'forwardable'

class Function
  extend Forwardable
  attr_accessor :name, :function
  def_delegators :@function, :call, :paramters

  def initialize(name, function)
    @name = name
    @function = function
  end

  def parameters_needed
    @function.parameters.size
  end

  def self.functions
    @funcs ||= {
      add:         Function.new('add',       lambda{|a,b| a+b}),
      sub:         Function.new('sub',       lambda{|a,b| a-b}),
      mul:         Function.new('mul',       lambda{|a,b| a*b}),
      isgreater:   Function.new('one_if_greater', lambda{|a,b| a>b ? 1 : 0}),
      if_not_zero: Function.new('ifnotzero', lambda{|a,b,c| a>0 ? b : c})
    }
  end

  def self.supported_functions
    functions.keys
  end

  def self.[](func)
    functions[func]
  end

  def self.random
    self[supported_functions.sample]
  end

end
