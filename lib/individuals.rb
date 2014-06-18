require 'bitset'
module Genetic
	class Individual
		attr_reader :gene
		attr_accessor :fitness
		
		def initialize(gene)
			@gene = gene
		end

		def <=>(other)
			if @fitness > other.fitness
				1
			elsif @fitness == other.fitness
				0
			else @fitness < other.fitness
				-1
			end
		end

		def set(bit)
			@gene.set bit
		end

		def clear(bit)
			@gene.clear bit
		end
	end
end