require_relative '../lib/population.rb'
require 'bitset'

fitness_func = lambda do |x|
	bi = Bitset.from_s('10001101')
	xor_gene = bi ^ x
	fitness = 0
	xor_gene.each_with_index do |bit, index|
		fitness += 2**index if bit
	end
	fitness
end

gene_to_item_func = lambda { |gene| gene }

pop = Genetic::Population.new(member_count: 30,
															member_length: 8,
															evolutions: 20,
															&fitness_func)

pop.evolve(&gene_to_item_func)