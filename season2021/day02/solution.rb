module Season2021
  module Day02
    class << self
      def input
        @input ||=
          File.read("#{__dir__}/input.txt").split("\n").map do |line|
            splitted = line.split
            {direction: splitted[0], change: splitted[1].to_i}
          end
      end
    end

    class Part1
      def execute
        @input = Day02.input
        @debth = @horizontal_position = @position = 0
        locate_positions
        @position = @debth * @horizontal_position

        puts "Day02, Part1, Result: #{@position}"
      end

      private

      def locate_positions
        @input.each do |command|
          case command[:direction]
          when 'forward'
            @horizontal_position += command[:change]
          when 'up'
            @debth -= command[:change]
          when 'down'
            @debth += command[:change]
          end
        end
      end
    end

    class Part2
      def execute
        @input = Day02.input
        @debth = @horizontal_position = @position = @aim = 0
        locate_positions
        @position = @debth * @horizontal_position

        puts "Day02, Part2, Result: #{@position}"
      end

      private

      def locate_positions
        @input.each do |command|
          change = command[:change]
          case command[:direction]
          when 'forward'
            @horizontal_position += change
            @debth += (@aim * change)
          when 'up'
            @aim -= change
          when 'down'
            @aim += change
          end
        end
      end
    end
  end
end

Season2021::Day02::Part1.new.execute
Season2021::Day02::Part2.new.execute
