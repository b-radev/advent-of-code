module Season2021
  module Day05
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").split("\n")
      end
    end

    class Part1
      def execute
        @input = Day05.input
        @dangerous = 0
        @grid = []
        extract_grid
        find_dangerous

        puts "Day05, Part1, Result: #{@dangerous}"
      end

      private

      def extract_grid
        @input.each do |input_line|
          coordinates = input_line.split ' -> '
          x1, y1 = coordinates[0].split(',').map(&:to_i)
          x2, y2 = coordinates[1].split(',').map(&:to_i)

          draw_line x1, y1, x2, y2
        end
      end

      def draw_line(x1, y1, x2, y2)
        return unless x1 == x2 || y1 == y2

        horizontal = y1 == y2
        if horizontal
          range = x1 < x2 ? x1..x2 : x2..x1
          range.each { |x| draw_point(x, y1) }
        else
          range = y1 < y2 ? y1..y2 : y2..y1
          range.each { |y| draw_point(x1, y) }
        end
      end

      def draw_point(x, y)
        (@grid.size..y).each { |i| @grid[i] = [] } if @grid.size < y + 1
        (@grid[y].size..x).each { |i| @grid[y][i] = 0 } if @grid[y].size < x + 1

        @grid[y][x] += 1
      end

      def find_dangerous
        @grid.each do |line|
          line.each do |column|
            @dangerous += 1 if column > 1
          end
        end
      end
    end

    class Part2
      def execute
        @input = Day05.input
        @dangerous = 0
        @grid = []
        extract_grid
        find_dangerous

        puts "Day05, Part2, Result: #{@dangerous}"
      end

      private

      def extract_grid
        @input.each do |input_line|
          coordinates = input_line.split ' -> '
          x1, y1 = coordinates[0].split(',').map(&:to_i)
          x2, y2 = coordinates[1].split(',').map(&:to_i)

          draw_line x1, y1, x2, y2
        end
      end

      def draw_line(x1, y1, x2, y2)
        if x1 == x2 || y1 == y2
          horizontal = y1 == y2
          if horizontal
            range = x1 < x2 ? x1..x2 : x2..x1
            range.each { |x| draw_point(x, y1) }
          else
            range = y1 < y2 ? y1..y2 : y2..y1
            range.each { |y| draw_point(x1, y) }
          end
        else
          range_x =
            if x1 < x2
              Array x1..x2
            else
              Array(x2..x1).reverse
            end

          range_y =
            if y1 < y2
              Array y1..y2
            else
              Array(y2..y1).reverse
            end

          range_y.each_with_index do |y, i|
            x = range_x[i]
            draw_point x, y
          end
        end
      end

      def draw_point(x, y)
        (@grid.size..y).each { |i| @grid[i] = [] } if @grid.size < y + 1
        (@grid[y].size..x).each { |i| @grid[y][i] = 0 } if @grid[y].size < x + 1

        @grid[y][x] += 1
      end

      def find_dangerous
        @grid.each do |line|
          line.each do |column|
            @dangerous += 1 if column > 1
          end
        end
      end
    end

    Part1.new.execute
    Part2.new.execute
  end
end

