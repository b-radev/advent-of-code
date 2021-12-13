module Season2021
  module Day12
    class << self
      def input
        @input ||= input = File.read("#{__dir__}/input.txt").split
      end

      def parse_cave_map
        cave_map = Hash.new { |hash, key| hash[key] = [] }

        input.each do |line|
          from, to = line.split('-')
          cave_map[from] << to
          cave_map[to] << from
        end

        cave_map
      end

      def small_cave?(name)
        name.match?(/^[a-z]+/)
      end

      def path_count(cave_map, already_visited, visited_list, from, to)
        return 1 if from == to

        if visited_list.include?(from)
            return 0 if already_visited || from == 'start'

            already_visited = true
        end

        cave_map[from].sum do |dest|
          visited_list += [from] if small_cave? from

          path_count cave_map, already_visited, visited_list, dest, to
        end
      end
    end

    class Part1
      def initialize
        @cave_map = Day12.parse_cave_map
      end

      def execute
        result = Day12.path_count(@cave_map, true, [], 'start', 'end')
        puts "Day12, Part1, Result: #{result}"
      end
    end

    class Part2
      def initialize
        @cave_map = Day12.parse_cave_map
      end

      def execute
        result = Day12.path_count(@cave_map, false, [], 'start', 'end')
        puts "Day12, Part2, Result: #{result}"
      end
    end

    Part1.new.execute
    Part2.new.execute
  end
end
