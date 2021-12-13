module Season2021
  module Day08
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").each_line.map{_1.split("|")}
      end
    end

    class Part1
      def initialize
        @signal_outputs = Day08.input.map{|line| line[1].strip.split(" ")}
      end

      def execute
        unique_digits_appearance_count
        puts "Day08, Part1, Result: #{unique_digits_appearance_count}"
      end

      private

      def unique_digits_appearance_count
        unique_count = 0
        @signal_outputs.each do |line|
          line.each do |output|
            unique_count += 1 if [2, 3, 4, 7].include? output.size
          end
        end

        unique_count
      end
    end

    class Part2
      def initialize
        @data = Day08.input
      end

      def execute
        sum = @data.sum{decode_segments(_1)}
        puts "Day08, Part2, Result: #{sum}"
      end

      private

      # NUM | CODE    | SEGMENTS
      # 0   | abcefg  | (6)
      # 6   | abdefg  | (6)
      # 9   | abcdfg  | (6)
      # 2   | acdeg   | (5)
      # 3   | acdfg   | (5)
      # 5   | abdfg   | (5)
      # 1   | cf      | (2)
      # 4   | bcdf    | (4)
      # 7   | acf     | (3)
      # 8   | abcdefg | (7)

      def convert(codes, outputs)
        case outputs.length
        when 2 then "1"
        when 3 then "7"
        when 4 then "4"
        when 5
          return "3" if outputs.include?(codes[:top_right]) && outputs.include?(codes[:bottom_right])
          return "2" if outputs.include?(codes[:top_right]) && outputs.include?(codes[:bottom_left])
          return "5" if outputs.include?(codes[:bottom_right]) && outputs.include?(codes[:top_left])
        when 6
          return "0" if !outputs.include?(codes[:center])
          return "6" if !outputs.include?(codes[:top_right])
          return "9" if !outputs.include?(codes[:bottom_left])
        else "8"
        end
      end

      def decode_segments(line)
        sorted_patterns = line[0].split(" ").sort{_1.length <=> _2.length}
        outputs = line[1].strip.split(" ")

        codes = %w(a b c d e f g)
        segement = Hash.new

        segement[:top] =
          codes.delete(
            codes.filter{
              sorted_patterns[1].include?(_1) &&
              !sorted_patterns[0].include?(_1)
            }.first
          )

        segement[:top_left] =
          codes.delete(
            codes.filter{
              sorted_patterns[2].include?(_1) &&
              !sorted_patterns[0].include?(_1) &&
              sorted_patterns[7].include?(_1) &&
              sorted_patterns[8].include?(_1) &&
              sorted_patterns[6].include?(_1)
            }.first
          )

        segement[:center] =
          codes.delete(
            codes.filter{
              sorted_patterns[2].include?(_1) &&
              !sorted_patterns[0].include?(_1)}.first
          )

        segement[:bottom_right] =
          codes.delete(
            codes.filter{
              sorted_patterns[0].include?(_1) &&
              sorted_patterns[6].include?(_1) &&
              sorted_patterns[7].include?(_1) &&
              sorted_patterns[8].include?(_1)
            }.first
          )

        segement[:top_right] =
          codes.delete(codes.filter{sorted_patterns[0].include?(_1)}.first)

        segement[:bottom] =
          codes.delete(
            codes.filter{
              sorted_patterns[3].include?(_1) &&
              sorted_patterns[4].include?(_1) &&
              sorted_patterns[5].include?(_1)
            }.first
          )

        segement[:bottom_left] = codes.first

        outputs.map{convert(segement, _1)}.join.to_i
      end
    end
  end
end

Season2021::Day08::Part1.new.execute
Season2021::Day08::Part2.new.execute
