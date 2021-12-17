module Season2021
  module Day17
    class << self
      def target
        @target ||= File.read("#{__dir__}/input.txt").scan(/target area: x=([^,]+), y=([^,]+)/)[0].map { eval _1 }
      end

      def simulation(velocity_x, velocity_y)
        target_range_x = target[0]
        target_range_y = target[1]
        scored = false
        max_y = 0
        x = 0
        y = 0

        until y < target_range_y.min
          x += velocity_x
          y += velocity_y
          velocity_x -= velocity_x.positive? ? 1 : velocity_x.negative? ? -1 : 0
          velocity_y -= 1
          max_y = y if y > max_y
          if target_range_x.include?(x) && target_range_y.include?(y)
              scored = true
              break
          end
        end

        {scored: scored, max_y: max_y}
      end

    end

    class Solution
      def initialize
        # target area: x=195..238, y=-93..-67
        velocity_combinations = (-250..250).to_a.product((-100..100).to_a)

        @possibilities =
          velocity_combinations.
            map { Day17.simulation _1, _2 }.
            select { _1[:scored] }
      end

      def execute
        max_y = @possibilities.map { _1[:max_y] }.max
        puts "Day17, Part1, Result: #{max_y}"

        distinct_velocities = @possibilities.count
        puts "Day17, Part2, Result: #{distinct_velocities}"
      end
    end

    Solution.new.execute
  end
end

