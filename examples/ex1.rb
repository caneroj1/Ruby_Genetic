require_relative '../lib/population.rb'

experiment_results = {}

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

20.times do |i|
	puts "TRIAL #: #{ i + 1 }"
	results = Genetic::Population.new(member_count: 50,
																member_length: 10,
																evolutions: 1000,
																mutations: false,
																display: false,
																&fitness_func).
																evolve(&gene_to_item_func)

	experiment_results[results[:value]] = results[:fitness]
end

data_array = experiment_results.to_a
data_array.sort! { |x, y| y[1] <=> x[1] }

puts experiment_results.inspect
