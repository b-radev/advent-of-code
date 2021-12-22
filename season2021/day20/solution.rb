module Season2021
  module Day20
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").lines.map(&:chomp)
      end
    end

    Point = Struct.new :x, :y

    class Part1
      def initialize
        @algorithm = Day20.input.first.chars.map { |char| char == '#' }
      end

      def execute
        image = ImmageScanner.new(@algorithm)
        Day20.input[2..].each_with_index do |row, x|
          row.chars.each_with_index do |char, y|
            image.mark_pixel(Point.new(x, y), (char == '#'))
          end
        end

        result = image.apply_algorithm.apply_algorithm.lit_pixel_count
        puts "Day20, Part1, Result: #{result}"
      end
    end

    class Part2
      def initialize
        @algorithm = Day20.input.first.chars.map { |char| char == '#' }
      end

      def execute
        image = ImmageScanner.new @algorithm
        Day20.input[2..].each_with_index do |row, x|
          row.chars.each_with_index do |char, y|
            image.mark_pixel(Point.new(x, y), (char == '#'))
          end
        end

        50.times do
          image = image.apply_algorithm
        end

        result = image.lit_pixel_count

        puts "Day20, Part2, Result: #{result}"
      end
    end

    class ImmageScanner
      def initialize(algorithm, pass = 0)
        # When the 0 index element of the algorithm is true, we need to
        # flip what the unknown input is, otherwise we would be starting
        # to put a rim around the image and would add unneeded lit pixels
        hash_default_value = algorithm.first ? pass.odd? : false

        @image = Hash.new(hash_default_value)
        @min_x = 0
        @min_y = 0
        @max_x = 0
        @max_y = 0
        @pass = pass
        @algorithm = algorithm
      end

      def mark_pixel(point, light_up)
        @max_x = [@max_x, point.x].max
        @max_y = [@max_y, point.y].max

        @min_x = [@min_x, point.x].min
        @min_y = [@min_y, point.y].min

        @image[point] = light_up
      end

      def apply_algorithm
        new_image = ImmageScanner.new(@algorithm, @pass + 1)
        start_x = @min_x - 1
        end_x = @max_x + 1

        start_y = @min_y - 1
        end_y = @max_y + 1

        start_x.upto(end_x) do |x|
          start_y.upto(end_y) do |y|
            point = Point.new(x, y)
            algo_pos = algorithm_index(point)
            new_image.mark_pixel(point, @algorithm[algo_pos])
          end
        end

        new_image
      end

      def algorithm_index(point)
        points = [
          Point.new(point.x - 1, point.y - 1),
          Point.new(point.x - 1, point.y),
          Point.new(point.x - 1, point.y + 1),

          Point.new(point.x,     point.y - 1),
          Point.new(point.x,     point.y),
          Point.new(point.x,     point.y + 1),

          Point.new(point.x + 1, point.y - 1),
          Point.new(point.x + 1, point.y),
          Point.new(point.x + 1, point.y + 1)
        ]

        points.map { |p| @image[p] ? '1' : '0' }.join.to_i(2)
      end

      def lit_pixel_count
        @image.values.count(&:itself)
      end
    end

    Part1.new.execute
    Part2.new.execute
  end
end
