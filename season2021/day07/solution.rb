module Season2021
  module Day07
    class << self
      def input
        File.read("#{__dir__}/input.txt").strip.split(",").map(&:to_i)
      end
    end

    class Part1
      def initialize
        @crab_positions = Day07.input
      end

      def execute
        puts "Day07, Part1, Result: #{min_fuel}"
      end

      private

      def fuel(destination)
        fuel = 0
        @crab_positions.each do |current_pos|
          fuel += (destination - current_pos).abs
        end

        fuel
      end

      def min_fuel
        min_fuel = fuel 0
        (1..@crab_positions.size).each do |position|
          min_fuel = [min_fuel, fuel(position)].min
        end

        min_fuel
      end
    end

    class Part2
      def initialize
        @crab_positions = Day07.input
      end

      def execute
        puts "Day07, Part2, Result: #{min_fuel}"
      end

      private

      def fuel(destination)
        fuel = 0
        @crab_positions.each do |current_pos|
          fuel += ((destination - current_pos).abs * ((destination - current_pos).abs + 1)) / 2
        end

        fuel
      end

      def min_fuel
        min_fuel = fuel 0
        (1..@crab_positions.size).each do |position|
          min_fuel = [min_fuel, fuel(position)].min
        end

        min_fuel
      end
    end

  end
end

Season2021::Day07::Part1.new.execute
Season2021::Day07::Part2.new.execute
