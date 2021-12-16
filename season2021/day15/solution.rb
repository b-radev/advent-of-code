# gem install pqueue
require 'pqueue'
require 'set'

module Season2021
  module Day15
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").strip.split("\n").map { |line| line.chars.map(&:to_i) }
      end

      def each_neighbour(grid, (x, y))
        yield [x, y - 1] if y > 0
        yield [x + 1, y] if x + 1 < grid[y].size
        yield [x, y + 1] if y + 1 < grid.size
        yield [x - 1, y] if x > 0
      end

      def find_path(grid)
        start = [0,0]
        target = [grid[0].size-1, grid.size-1]

        visited = Set[]
        initial = [start, 0]
        queue = PQueue.new([initial]) { |a, b| a.last < b.last }

        while !queue.empty?
          position, risk = queue.pop

          next unless visited.add?(position)
          return risk if position == target

          each_neighbour(grid, position) { |x,y|
            queue.push([[x,y], risk + grid[y][x]])
          }
        end
      end
    end

    class Part1
      def initialize
        @input = Day15.input
      end

      def execute
        result = Day15.find_path @input

        puts "Day15, Part1, Result: #{result}"
      end
    end

    class Part2
      def initialize
        @input = Day15.input
      end

      def execute
        large_map = enlarge_map @input, times: 5
        result = Day15.find_path large_map
        puts "Day15, Part2, Result: #{result}"
      end

      private

      def enlarge_map(input, times: 1)
        times.times.flat_map {|y|
          input.map { |row|
            times.times.flat_map {|x|
              row.map { |risk|
                new_risk = risk + y + x
                while new_risk > 9
                  new_risk -= 9
                end
                new_risk
              }
            }
          }
        }
      end
    end


    Part1.new.execute
    Part2.new.execute
  end
end

