require 'bitset'
require_relative 'individuals.rb'

module Genetic
	## population will be the class that will store a bunch of genes (in the population array)
	## the elements of the array are bitsets which will be initialized with a specified length
	## and a random value
	class Population
		include Enumerable
		attr_reader :individuals, :member_count, :member_length, :fitness, :display
		attr_accessor :evolution_count

		## initialize method will accept attributes to initialize the population
		## with: number of bitsets, length of each bitset, and the fitness function
		def initialize(options = {}, &fitness_func)
			raise ArgumentError, "Fitness function is required. Pass in a block." unless block_given?
			raise ArgumentError, "Parameters must include :member_count, :member_length" if options[:member_count].nil? || options[:member_length].nil?

			@do_mutations = options[:mutations].nil? ? false : options[:mutations]
			@evolution_count = options[:evolutions].nil? ? 15 : options[:evolutions]
			@display = options[:display].nil? ? false : options[:display]
			@member_length, @member_count, @fitness = options[:member_length], options[:member_count], fitness_func

			randomize_bitsets
		end

		def evolve(&gene_to_real_value_block)
			raise ArgumentError, "This function must be provided a block to convert a gene into a unit that can be evaluated in the fitness function" unless block_given?
			evaluate_fitness(&gene_to_real_value_block)

			@evolution_count.times do
				fit_parents = tournament_selection
				children = crossover(fit_parents)
				@individuals = restore_population(children)
				mutate if @do_mutations
				evaluate_fitness(&gene_to_real_value_block)
			end

			disp_results(&gene_to_real_value_block)
		end

		def each
			@individuals.each { |x| yield x }
		end

		private
		def disp_results(&gene_to_real_value_block)
			sort_by_fitness
			best_individual = @individuals[@member_count - 1]
			best_value = gene_to_real_value_block.call(best_individual.gene)

			if @display
				puts "Most Fit Gene: #{best_individual.gene}"
				puts "Gene Value: #{best_value}"
				puts "Fitness: #{best_individual.fitness}"
			end

			{ value: best_value, fitness: best_individual.fitness }
		end

		def randomize_bitsets
			@individuals = []
 			@member_count.times { |x| @individuals << Genetic::Individual.new(Bitset.from_s(generate_random_binary)) }
		end

		def tournament_selection
			winners = []

			tourney_array = populate_tournament_array
			@member_count.times { winners << tourney_array[Kernel.rand(0...tourney_array.count)] }
			winners
		end

		def populate_tournament_array
			population_copy = []
			total_fitness = @individuals.inject(0) { |fitness, individual| fitness += individual.fitness }

			@individuals.each do |individual|
				((individual.fitness / total_fitness) * 100).ceil.times do
					population_copy << individual
				end
			end

			population_copy
		end

		def crossover(fit_parents)
			results = []
			while fit_parents.count > 0
				crossover_point = (Kernel.rand(@member_length))

				parent_one = Kernel.rand % fit_parents.count
				parent_one = fit_parents.delete_at(parent_one)
				parent_two = Kernel.rand % fit_parents.count
				parent_two = fit_parents.delete_at(parent_two)

				parent_one.gene.each_with_index do |bit, index|
					if index >= crossover_point
						parent_one.gene[index] = parent_two.gene[index]
						parent_two.gene[index] = bit
					end
				end

				results << parent_one
				results << parent_two
			end
			results
		end

		def mutate
			@individuals.each do |ind|
				ind.gene.each_with_index do |bit, index|
					ind.gene[index] = !ind.gene[index] if Kernel.rand(@member_length).eql? 0
				end
			end
		end

		def restore_population(children)
			sort_by_fitness
			while children.count < @member_count
				children << @individuals.delete_at(@individuals.count - 1)
			end
			children
		end

		def generate_random_binary
			binary_string = ""
			@member_length.times do
				if Kernel.rand(0.0..1.0) < 0.5
					binary_string << "0"
				else
					binary_string << "1"
				end
			end
			binary_string
		end

		def evaluate_fitness(&gene_to_real_value_block)
			@individuals.each { |individual| individual.fitness = @fitness.call(gene_to_real_value_block.call(individual.gene)) }
		end

		def sort_by_fitness
			@individuals.sort!
		end
	end
end
