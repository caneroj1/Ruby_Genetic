require_relative '../lib/experiment'

fitness_func = lambda do |x|
	val = x**2 + 2 * x - 11
	begin
		fitness = (1000 * (1.0/(val - 10))).abs
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

Genetic::Experiment.new(member_count: 50,
												member_length: 10,
												iterations: 30,
												evolutions: 1000,
												mutations: false,
												display: false,
												fitness: fitness_func,
												real: gene_to_item_func).run
