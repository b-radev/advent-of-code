module Season2021
  module Day09

    Point = Struct.new :x, :y, :value

    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").split("\n").map{_1.split("").map(&:to_i)}
      end

      def find_neighbours(point, points)
        left   = points.find { _1.x == point.x - 1 && _1.y == point.y     }
        up     = points.find { _1.x == point.x     && _1.y == point.y - 1 }
        right  = points.find { _1.x == point.x + 1 && _1.y == point.y     }
        bottom = points.find { _1.x == point.x     && _1.y == point.y + 1 }

        [up, right, bottom, left].compact
      end
    end

    class Part1
      def initialize
        @points = []
        Day09.input.each_with_index {|line, li| line.each_with_index{|point, pi| @points << Point.new(li, pi, point) }}
      end

      def execute
        @low_points = []
        find_low_points
        risk_levels_sum = @low_points.map{_1.value}.sum{_1 + 1}
        puts "Day09, Part1, Result: #{risk_levels_sum}"
      end

      private

      def find_low_points
        @points.each do |point|
          next if point.value == 9

          if Day09.find_neighbours(point, @points).reject{_1.nil?}.map{ _1.value}.min > point.value
            @low_points << point
          end
        end
      end
    end

    class Part2
      def initialize
        @points = []
        Day09.input.each_with_index {|line, li| line.each_with_index{|point, pi| @points << Point.new(li, pi, point) }}
      end

      def execute
        @basins = [[]]
        find_basins
        result = @basins.map(&:count).sort.reverse.first(3).reduce(&:*)
        puts "Day09, Part2, Result: #{result}"
      end

      private

      def find_basins
        checked = []

        @points.each do |point|
          next if point.value == 9 || checked.include?(point)

          to_be_checked = [point]

          while to_be_checked.any?
            to_be_checked -= checked
            next if to_be_checked.empty?

            current = to_be_checked.shift
            neighbours = Day09.find_neighbours(current, @points)

            @basins[-1] << current.value
            checked << current
            to_be_checked << (neighbours - checked).filter { _1.value < 9 }
            to_be_checked = to_be_checked.flatten.uniq
          end

          @basins << []
        end
      end
    end
  end
end

Season2021::Day09::Part1.new.execute
Season2021::Day09::Part2.new.execute
