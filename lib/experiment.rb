require_relative 'population'

module Genetic
  ## an experiment will allow a user to run their genetic algorithm
  # an arbitrary number of times and return a report on their findings
  class Experiment
    attr_accessor :iterations,
                  :member_count,
                  :member_length,
                  :reports,
                  :evolutions,
                  :mutations,
                  :fitness,
                  :gene_to_real

    def initialize(opts)
      process_options(opts)
    end

    def run
      puts "Beginning experiment. Running #{@iterations} times, evolving #{@evolutions} times per run."
      experiment_results = {}
      @iterations.times do |i|
        puts "Executing Trial #: #{ i + 1}"
        results = Genetic::Population.new(member_count:  @member_count,
                                          member_length: @member_length,
                                          evolutions:    @evolutions,
                                          mutations:     @mutations,
                                          display:       @reports,
                                                         &@fitness).
                                          evolve(&@gene_to_real)

      experiment_results[results[:value]] = results[:fitness]
      end

      display_report(experiment_results)
    end

    private

    def display_report(experiment_results)
      data_array = experiment_results.to_a
      data_array.sort! { |x, y| y[1] <=> x[1] }
      data_array.each.with_index do |data, index|
        puts "##{index + 1}\n\tValue: #{data[0]}\n\tFitness: #{data[1]}"
      end
    end

    def process_options(opts)
      raise ArgumentError, fitness_error if no_fitness(opts[:fitness])
      raise ArgumentError, gene_to_value_error if no_gene_to_value(opts[:real])

      @fitness = opts[:fitness]
      @gene_to_real = opts[:real]

      @iterations = opts[:iterations].nil? ? 50 : opts[:iterations]
      @evolutions = opts[:evolutions].nil? ? 100 : opts[:evolutions]
      @member_count = opts[:member_count].nil? ? 20 : opts[:member_count]
      @member_length = opts[:member_length].nil? ? 8 : opts[:member_length]
      @display = opts[:reports].nil? ? false : opts[:reports]
      @mutations = opts[:mutations].nil? ? false : opts[:mutations]
    end

    def fitness_error
      <<-FITNESS
        Fitness Function block is required. Please pass in a block with the key
        "fitness" as a symbol.
      FITNESS
    end

    def gene_to_value_error
      <<-GENE
        Gene to Real Value block is required. Please pass in a block with the key
        "real" as a symbol.
      GENE
    end

    def no_fitness(fit)
      return true if fit.nil?
      !fit.class.eql?(Proc)
    end

    def no_gene_to_value(real)
      return true if real.nil?
      !real.class.eql?(Proc)
    end
  end
end
