require_relative '../lib/population.rb'
require_relative '../lib/individuals.rb'
require 'spec_config.rb'

describe Genetic::Population do
	it 'should be able to generate a random binary string' do
		test_unit = Genetic::Population.new(:member_count => 1, :member_length => 5) { "testing" }
		expect(test_unit.individuals[0].gene).not_to eq(nil)
	end

	it 'should be able to generate multiple bitsets' do
		test_unit = Genetic::Population.new(:member_count => 5, :member_length => 5) { "testing" }
		expect(test_unit.individuals.count).to eq(5)
	end

	it 'should be able to execute its fitness function' do
		test_unit = Genetic::Population.new(:member_count => 1, :member_length => 5) { "testing" }
		expect(test_unit.fitness.call).to eq("testing")
	end

	it 'should raise an Argument Error when there is no fitness function' do
		begin
			test_unit = Genetic::Population.new(:member_count => 0, :member_length => 1)
		rescue => e
			expect(e.class).to eq(ArgumentError)
		end
	end

	it 'should raise an Argument Error when there is no member_count' do
		begin
			test_unit = Genetic::Population.new(:member_length => 1) { "testing" }
		rescue => e
			expect(e.class).to eq(ArgumentError)
		end
	end

	it 'should raise an Argument Error when there is no member_length' do
		begin
			test_unit = Genetic::Population.new(:member_count => 1) { "testing" }
		rescue => e
			expect(e.class).to eq(ArgumentError)
		end
	end

	it 'should be able to evaluate the fitness of its individuals' do
		test_unit = Genetic::Population.new(:member_count => 1, :member_length => 1) { |x| 2 * x + 12 }

		ind = test_unit.individuals[0]
		def ind.gene
			[false, true]
		end

		test_unit.send(:evaluate_fitness) do |gene|
			result = 0
			gene.each_with_index { |bit, index| result += 2**index if bit }
			result
		end

		expect(test_unit.individuals[0].fitness).to eq 16
	end

	it 'should be able to sort the individuals according to their fitness' do
		test_unit = Genetic::Population.new(:member_count => 5, :member_length => 3) { "sort_test" }
		fitness_arr = [3, 1, 2, 7, 0]
		test_unit.map.with_index { |unit, index| unit.fitness = fitness_arr[index] }

		test_unit.send(:sort_by_fitness)
		fitness_arr.sort!

		test_unit.each_with_index { |unit, index| expect(unit.fitness).to eq fitness_arr[index] }
	end

	it 'should be able to mutate a gene' do
		Kernel.stub(:rand).and_return(0)

		test_unit = Genetic::Population.new(:member_count => 1, :member_length => 4) { "mutate_test" }
		individual = test_unit.individuals[0]
		expected_gene = Bitset.from_s("1111")

		test_unit.send(:mutate)
		4.times { |i| expect(test_unit.individuals[0].gene[i]).to eq expected_gene[i] }
	end

	it 'should be able to perform a crossover' do
		Kernel.stub(:rand).and_return(5)
		test_unit = Genetic::Population.new(:member_count => 2, :member_length => 10) { "crossover_test" }
		i1, i2 = test_unit.individuals[0], test_unit.individuals[1]

		def i1.gene=(g)
			@gene = g
		end

		def i2.gene=(g)
			@gene = g
		end

		def test_unit.modify_individual(ind, gene)
			@individuals[ind].gene = Bitset.from_s(gene)
		end


		test_unit.modify_individual(0, "1010110001")
		test_unit.modify_individual(1, "1100101101")

		expect_one_gene = Bitset.from_s("1010101101")
		expect_two_gene = Bitset.from_s("1100110001")

		test_unit.send(:crossover, [test_unit.individuals[0], test_unit.individuals[1]])

		10.times do |i|
			expect(test_unit.individuals[0].gene[i]).to eq expect_one_gene[i]
			expect(test_unit.individuals[1].gene[i]).to eq expect_two_gene[i]
		end
	end

	it 'should be able to run a tournament' do
		Kernel.stub(:rand).and_return(0)
		test_unit = Genetic::Population.new(:member_count => 5, :member_length => 4) { "tournament_test" }

		def test_unit.modify_individual(ind, gene)
			@individuals[ind].gene = Bitset.from_s(gene)
		end

		bit_array = %w{ 0000 0001 0010 0011 0100 }

		test_unit.each_with_index do |unit, index|
			def unit.gene=(g)
				@gene = g
			end
			unit.fitness = index
			test_unit.modify_individual(index, bit_array[index])
		end

		winners = test_unit.send(:tournament_selection)
		expect(winners.count).to eq test_unit.member_count
	end
end
