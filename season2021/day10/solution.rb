module Season2021
  module Day10
      NOT_VALID_CHAR = '*'
      OPENING_CHARS = "([{<".chars
      CLOSING_CHARS = ")]}>".chars

    class << self
      def input
        @input ||= File.read("#{__dir__}/test.txt").split("\n")
      end
    end

    class Part1
      def initialize
        @lines = Day10.input
      end

      def execute
        @score = 0
        find_invalid_score
        puts "Day10, Part1, Result: #{@score}"
      end

      private

      def find_invalid_score
        invalid_chars = []
        char_matches = Day10::CLOSING_CHARS.zip(Day10::OPENING_CHARS).to_h

        @lines.each do |line|
          store = []

          line.each_char do |char|
            if Day10::OPENING_CHARS.include? char
              store << char
            elsif Day10::CLOSING_CHARS.include? char
              next if store.pop == char_matches[char]

              invalid_chars << char
              store << Day10::NOT_VALID_CHAR
              break
            end
          end

          next if store.last == Day10::NOT_VALID_CHAR
        end

        points = Day10::CLOSING_CHARS.zip([3, 57, 1197, 25137]).to_h
        @score = invalid_chars.map { points[_1] }.sum
      end
    end

    class Part2
      def initialize
        @lines = Day10.input
      end

      def execute
        @score = 0
        find_incomplete_score
        puts "Day10, Part1, Result: #{@score}"
      end

      private

      def find_incomplete_score
        invalid_chars = []
        char_matches = Day10::CLOSING_CHARS.zip(Day10::OPENING_CHARS).to_h
        values = Day10::OPENING_CHARS.zip([1, 2, 3, 4]).to_h

        score =
          @lines.map do |line|
            tags = []

            line.each_char do |char|
              case char
              when *Day10::OPENING_CHARS
                tags << char
              when *Day10::CLOSING_CHARS
                next if tags.pop == char_matches[char]

                invalid_chars << char
                tags << Day10::NOT_VALID_CHAR

                break
              end
            end

            next if tags.last == Day10::NOT_VALID_CHAR

            tags.reverse.reduce(0) do |sum, char|
              sum * 5 + values.fetch(char)
            end
          end.compact

        @score = score.sort[score.size / 2]
      end
    end
  end
end

Season2021::Day10::Part1.new.execute
Season2021::Day10::Part2.new.execute
