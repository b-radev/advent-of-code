module Season2021
  module Day06
    class << self
      def input
        @input||= File.read("#{__dir__}/input.txt").strip.split(",").map(&:to_i)
      end
    end

    class Solution
      def initialize(days)
        @days = days
        @fish = Day06.input
        @population = [0] * 9
        @fish.each do |count|
          @population[count] += 1
        end
      end

      def execute
        puts "Day06, Solution for #{@days}, Result: #{calculate_fish_population_for(@days)}"
      end

      private

      def calculate_fish_population_for(days)
        days.times do
          fish_to_give_birth, *remaining = @population
          @population = remaining << fish_to_give_birth
          @population[6] += fish_to_give_birth
        end

        @population.sum
      end
    end

    Solution.new(80).execute
    Solution.new(256).execute
  end
end

