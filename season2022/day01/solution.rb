module Season2021
  module Day01
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").split("\n\n").map {|group| group.split.map(&:to_i).sum}
      end
    end

    class Part1
      def execute
        @input = Day01.input

        puts "Day01, Part1, Result: #{@input.max}"
      end
    end

    class Part2
      def execute
        @input = Day01.input

        puts "Day01, Part1, Result: #{@input.sort.reverse!.first(3).sum}"
      end
    end

    Part1.new.execute
    Part2.new.execute
  end
end



