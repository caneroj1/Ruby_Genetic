require_relative '../lib/population.rb'

population = Genetic::Population.new(:member_length => 10, :member_count => 5) { |x| 2 * x + 113 }
population.each_with_index { |e| e.fitness = rand % 20 + 1 }

puts "Tournament"
winner = population.send(:run_tournament)
puts winner.inspect
winner = population.send(:run_tournament)
puts winner.inspect

puts "Crossovers"
pop2 = Genetic::Population.new(:member_length => 10, :member_count => 2) { "test" }
puts pop2.individuals[0].gene
puts pop2.individuals[1].gene
pop2.send(:crossover, [pop2.individuals[0].gene, pop2.individuals[1].gene])
puts pop2.individuals[0].gene
puts pop2.individuals[1].gene

pop3 = Genetic::Population.new(:member_length => 10, :member_count => 1) { "test" }
puts "\nMutating\n#{pop3.individuals[0].gene}"
pop3.send(:mutate)
puts pop3.individuals[0].gene