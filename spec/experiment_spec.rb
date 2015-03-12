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

  context 'Processing Options' do
    let(:fitness) { lambda { 0 } }
    let(:real)    { lambda { 0 } }

    describe 'iterations' do
      it 'should process option correctly' do
        expect(Genetic::Experiment.new(iterations: 10, fitness: fitness, real: real).iterations).to eq(10)
      end

      it 'should default when not present' do
        expect(Genetic::Experiment.new(iterations: nil, fitness: fitness, real: real).iterations).to eq(50)
      end
    end

    describe 'evolutions' do
      it 'should process option correctly' do
        expect(expect(Genetic::Experiment.new(evolutions: 10, fitness: fitness, real: real).evolutions).to eq(10))
      end

      it 'should default when not present' do
        expect(Genetic::Experiment.new(evolutions: nil, fitness: fitness, real: real).evolutions).to eq(100)
      end
    end

    describe 'member count' do
      it 'should process option correctly' do
        expect(Genetic::Experiment.new(member_count: 10, fitness: fitness, real: real).member_count).to eq(10)
      end

      it 'should default when not present' do
        expect(Genetic::Experiment.new(member_count: nil, fitness: fitness, real: real).member_count).to eq(20)
      end
    end

    describe 'member length' do
      it 'should process option correctly' do
        expect(Genetic::Experiment.new(member_length: 10, fitness: fitness, real: real).member_length).to eq(10)
      end

      it 'should default when not present' do
        expect(Genetic::Experiment.new(member_length: nil, fitness: fitness, real: real).member_length).to eq(8)
      end
    end

    describe 'reports' do
      it 'should process option correctly' do
        expect(Genetic::Experiment.new(reports: true, fitness: fitness, real: real).reports).to eq(true)
      end

      it 'should default when not present' do
        expect(Genetic::Experiment.new(reports: nil, fitness: fitness, real: real).reports).to eq(false)
      end
    end

    describe 'mutations' do
      it 'should process option correctly' do
        expect(Genetic::Experiment.new(mutations: true, fitness: fitness, real: real).mutations).to eq(true)
      end

      it 'should default when not present' do
        expect(Genetic::Experiment.new(mutations: nil, fitness: fitness, real: real).mutations).to eq(false)
      end
    end
  end
end
