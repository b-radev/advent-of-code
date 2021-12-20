require 'matrix'
require 'set'

module Season2021
  module Day19
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt")
      end
    end

    class Solution
      def initialize
        @scanners =
          Day19.input.split("\n\n").map do |scanner|
            scanner
              .split("\n")[1..]
              .map { _1.split(',').map(&:to_i) }
              .map { combinations _1 }
              .transpose
          end

        @scanner_hashes = find_scanner_hashes @scanners
      end

      def execute
        mappings =
          (0...@scanners.length).to_a.permutation(2).map do |a, b|
            first_scanner = @scanner_hashes[a][0]
            second_scanner = @scanner_hashes[b]
            idx = second_scanner.find_index { _1.intersection(first_scanner).length >= 12 }
            next unless idx

            [a, b, idx, find_offset(@scanners[a][0], @scanners[b][idx])]
          end.compact

        scanner_positions = [Vector[0, 0, 0]]
        beacon_positions = @scanners[0][0]
        positions_map = { 0 => [] }

        loop do
          mapping = mappings.find { positions_map.include?(_1) && !positions_map.include?(_2) }
          first_scanner_pos, second_scanner_pos, idx, offset = mapping
          positions_map[second_scanner_pos] = [[idx, offset]] + positions_map[first_scanner_pos]

          position = [offset] + @scanners[second_scanner_pos][idx].map { |elem| elem + offset }
          positions_map[first_scanner_pos].each do |f_idx, f_offset|
            position.map! { |elem| combine_by(elem, f_idx) + f_offset }
          end

          scanner_positions << position.shift
          beacon_positions = (beacon_positions + position).uniq

          break if positions_map.length == @scanners.length
        end

        result1 = beacon_positions.length
        puts "Day19, Part1, Result: #{result1}"

        result2 = scanner_positions.combination(2).map { |a, b| (b - a).map(&:abs).sum }.max
        puts "Day19, Part2, Result: #{result2}"
      end

      def find_scanner_hashes(scanners)
        scanners.map do |scanner_combinations|
          scanner_combinations.map do |combination|
            combination.map { |elem| (combination - [elem]).map { elem - _1 }.min_by(&:magnitude) }
          end
        end
      end

      def find_offset(first_scanner_data, second_scanner_data)
        second_scanner_data[0..13].product(first_scanner_data).each do |first_scanner_coord, second_scanner_coord|
          offset = second_scanner_coord - first_scanner_coord
          return offset if second_scanner_data.map { |e| e + offset }.intersection(first_scanner_data).length >= 12
        end
      end

      def combinations(position)
        (0..2).flat_map do |rot_idx|
          x, y, z = position.rotate(rot_idx)
          [
            [ x,  y,  z],
            [ x, -y, -z],
            [ x, -z,  y],
            [ x,  z, -y],
            [-x,  y, -z],
            [-x, -z, -y],
            [-x, -y,  z],
            [-x,  z,  y]
          ]
        end.map { Vector[*_1] }
      end

      def combine_by(coord, idx)
        combinations([1, 2, 3])[idx].map { |i| i.negative? ? -coord[-i - 1] : coord[i - 1] }
      end
    end

    Solution.new.execute
  end
end
