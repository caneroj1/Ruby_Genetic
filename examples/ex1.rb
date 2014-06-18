require_relative '../lib/population.rb'

fitness_func = lambda do |x|
	val = x**2 + 2 * x - 11
	fitness = (0 - val).abs
	begin 
		fitness = 1.0 / fitness
	rescue => e
		fitness = 99999
	end
	fitness
end

gene_to_item_func = lambda do |gene|
	value = 0
	gene.each_with_index { |bit, index| value += 2**index if bit }
	value
end

pop = Genetic::Population.new(member_count: 50, member_length: 10, evolutions: 15, mutations: false, &fitness_func)

pop.evolve(&gene_to_item_func)