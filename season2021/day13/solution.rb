module Season2021
  module Day13
    class << self
      def input
        @input ||= input = File.read("#{__dir__}/input.txt").chomp
      end

      def coordinates_and_instructions
        coordinates_list, instructions_list = input.split "\n\n"
        coordinates = coordinates_list.split("\n").map{ |c| c.split(',').map(&:to_i) }
        instructions = instructions_list.split("\n").map { |i| i.split(' ').last.split('=') }.map { |c, v| c == 'x' ? [v.to_i, 0] : [0, v.to_i] }
        [coordinates, instructions]
      end

      def fold(coordinates, point)
        x, y = point
        coordinates.map do |cx, cy|
          cx = x.zero? ? cx : x - (x - cx).abs
          cy = y.zero? ? cy : y - (y - cy).abs
          [cx, cy]
        end
      end
    end

    class Part1
      def initialize
        @coordinates, @instructions = Day13.coordinates_and_instructions
      end

      def execute
        @coordinates = @coordinates.map &:dup
        result = Day13.fold @coordinates, @instructions[0]
        puts "Day13, Part1, Result: #{result.uniq.size}"
      end
    end

    class Part2
      def initialize
        @coordinates, @instructions = Day13.coordinates_and_instructions
      end

      def execute
        @instructions.each { @coordinates = Day13.fold(@coordinates, _1) }
        puts 'Day13, Part2, Result:'
        display @coordinates
      end

      private

      def display(coordinates)
        map = coordinates.each_with_object({}) { |x, y| y[x] = true }
        max_x = coordinates.map(&:first).max + 1
        max_y = coordinates.map(&:last).max + 1
        max_y.times do |y|
          max_x.times do |x|
            print map[[x, y]] ? '#' : ' '
          end

          puts
        end
      end
    end

    Part1.new.execute
    Part2.new.execute
  end
end

