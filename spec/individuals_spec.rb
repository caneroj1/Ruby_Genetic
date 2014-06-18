require_relative '../lib/individuals.rb'
require 'spec_config.rb'
require 'bitset'

describe Genetic::Individual do

	it 'should be able to hold a gene' do
		expected_gene = Bitset.from_s "00101110"
		test_unit = Genetic::Individual.new(expected_gene)
		expect(test_unit.gene).to eq(expected_gene)
	end

	it 'should be able to set a bit in the gene' do
		expected_gene = Bitset.from_s "00101110"
		test_unit = Genetic::Individual.new(expected_gene)
		test_unit.set 0
		expect(test_unit.gene[0]).to eq true
	end

	it 'should be able to clear a bit in the gene' do
		expected_gene = Bitset.from_s "00101110"
		test_unit = Genetic::Individual.new(expected_gene)
		test_unit.clear 2
		expect(test_unit.gene[2]).to eq false
	end
end