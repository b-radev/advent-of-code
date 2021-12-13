module Season2021
  module Day11
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").split("\n").map{_1.split("").map(&:to_i)}
      end

      def flashing_nearby_count(map, x, y)
        flashing_count = 1
        left =  [0, x - 1].max
        right = [map[y].size - 1, x + 1].min
        upper = [0, y - 1].max
        lower = [map.size - 1, y + 1].min

        (upper..lower).each do |nearby_y|
          (left..right).each do |nearby_x|
            map[nearby_y][nearby_x] += 1
            flashing_count += flashing_nearby_count(map, nearby_x, nearby_y) if map[nearby_y][nearby_x] == 10
          end
        end

        flashing_count
      end
    end

    class Part1
      def initialize
        @flashing_count = 0
        @octopus_map = Day11.input
      end

      def execute
        100.times { find_flashing_count }
        puts "Day11, Part1, Result: #{@flashing_count}"
      end

      private

      def find_flashing_count
        @octopus_map.size.times do |y|
          @octopus_map[y].size.times do |x|
            @octopus_map[y][x] += 1
            @flashing_count += Day11.flashing_nearby_count(@octopus_map, x, y) if @octopus_map[y][x] == 10
          end
        end

        @octopus_map.each{|row| row.map!{_1 > 9 ? 0 : _1}}
      end
    end

    class Part2
      def initialize
        @flashing_count = 0
        @octopus_map = Day11.input
      end

      def execute
        @first_total_flash_step = 0
        find_first_total_flash_step
        puts "Day11, Part2, Result: #{@first_total_flash_step}"
      end

      private

      def find_first_total_flash_step
        total_flashes_count = @octopus_map.size * @octopus_map.first.size

        while @flashing_count != total_flashes_count do
          @flashing_count = 0

          find_flashing_count

          @first_total_flash_step += 1
        end
      end

      def find_flashing_count()
        @octopus_map.size.times do |y|
          @octopus_map[y].size.times do |x|
            @octopus_map[y][x] += 1
            @flashing_count += Day11.flashing_nearby_count(@octopus_map, x, y) if @octopus_map[y][x] == 10
          end
        end

        @octopus_map.each{|row| row.map!{_1 > 9 ? 0 : _1}}
      end
    end

    Part1.new.execute
    Part2.new.execute
  end
end
