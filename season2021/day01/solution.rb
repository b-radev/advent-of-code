module Season2021
  module Day01
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").split.map &:to_i
      end
    end

    class Part1
      def execute
        @input = Day01.input
        @larger_mesasurements_count = 0
        count_larger_mesasurements

        puts "Day01, Part1, Result: #{@larger_mesasurements_count}"
      end

      private

      def count_larger_mesasurements
        (1...@input.size).each do |index|
          @larger_mesasurements_count += 1 if @input[index] > @input[index - 1]
        end
      end
    end

    class Part2
      def execute
        @input = Day01.input
        @larger_sum_mesasurements_count = 0
        count_larger_mesasurements

        puts "Day01, Part2, Result: #{@larger_sum_mesasurements_count}"
      end

      private

      def count_larger_mesasurements
        current_sum = nil
        prev_sum = nil
        last_index = @input.size - 1

        (1...last_index).each do |index|
          current_sum = @input[index - 1] + @input[index] + @input[index + 1]
          @larger_sum_mesasurements_count += 1 if prev_sum && (current_sum > prev_sum)
          prev_sum = current_sum
        end
      end
    end

    Part1.new.execute
    Part2.new.execute
  end
end



