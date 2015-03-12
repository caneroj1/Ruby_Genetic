require_relative '../lib/experiment'
require 'spec_config.rb'

describe Genetic::Experiment do
  it 'should raise an ArgumentError with no fitness function' do
    expect { Genetic::Experiment.new(member_length: 1) }.to raise_error(ArgumentError)
  end

  it 'should raise an ArgumentError if the fitness function is not a block' do
    expect { Genetic::Experiment.new(fitness_function: 10) }.to raise_error(ArgumentError)
  end

  it 'should raise an ArgumentError with no gene to real value function' do
    expect { Genetic::Experiment.new(member_length: 1) }.to raise_error(ArgumentError)
  end

  it 'should raise an ArgumentError if the gene to real value function is not a block' do
    expect { Genetic::Experiment.new(real: 10) }.to raise_error(ArgumentError)
  end

  
end
