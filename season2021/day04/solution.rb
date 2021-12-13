module Season2021
  module Day04
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").split("\n")
      end
    end

    class Part1
      def execute
        @input = Day04.input
        @drawn_numbers = []
        @boards = []
        @marked_sum = @unmarked_sum = 0
        extract_boards
        find_bingo
        calculate_unmarked
        @score = @bingo_number * @unmarked_sum

        puts "Day04, Part1, Result: #{@score}"
      end

      private

      def extract_boards
        board = []
        @input.each_with_index do |input_line, index|
          if input_line.include? ','
            @drawn_numbers = input_line.strip.split(',').map(&:to_i)
            next
          end

          if input_line.strip.empty?
            next if board.empty?

            @boards << board
            board = []

            next
          end

          board << input_line.strip.split.map { |l| {l.to_i => false} }
          @boards << board if input_line == @input.last
        end
      end

      def find_bingo
        bingo_found = false

        @drawn_numbers.each do |drawn_number|
          break if bingo_found

          @boards.each do |board|
            break if bingo_found

            board.each do |line|
              break if bingo_found

              line.each do |number|
                number[drawn_number] = true unless number[drawn_number].nil?

                if line.map{_1.values.first}.none?(false)
                  bingo_found = true
                  @bingo_number = drawn_number
                  @bingo_board = board
                  break
                end
              end
            end
          end
        end
      end

      def calculate_unmarked
        @bingo_board.each do |line|
          line.reject { |n| n.values.first }.each { |h| @unmarked_sum += h.keys.first }
        end
      end
    end

    class Part2
      def execute
        @input = Day04.input
        @drawn_numbers = []
        @boards = []
        @marked_sum = @unmarked_sum = 0
        extract_boards
        find_bingos
        calculate_unmarked
        @score = @last_bingo_number * @unmarked_sum

        puts "Day04, Part2, Result: #{@score}"
      end

      private

      def extract_boards
        board = []
        Day04.input.each_with_index do |input_line, index|
          if input_line.include? ','
            @drawn_numbers = input_line.strip.split(',').map(&:to_i)
            next
          end

          if input_line.strip.empty?
            next if board.empty?

            @boards << board
            board = []

            next
          end

          board << input_line.strip.split.map { |l| {l.to_i => false} }
          @boards << board if input_line == Day04.input.last
        end
      end

      def find_bingos
        @boards_with_bingo = []
        board_has_bingo = false

        @drawn_numbers.each do |drawn_number|
          @boards.each do |board|
            next if @boards_with_bingo.include? board

            break if board_has_bingo

            board.each do |line|
              break if board_has_bingo

              line.each do |number|
                break if board_has_bingo

                number[drawn_number] = true unless number[drawn_number].nil?

                number_index_in_line = line.find_index number
                column = board.map {|l| l[number_index_in_line] }

                if line.map{_1.values.first}.none?(false) || column.map{_1.values.first}.none?(false)

                  @boards_with_bingo << board
                  board_has_bingo = true

                  if @boards_with_bingo.count == @boards.count
                    @last_bingo_number = drawn_number
                  end

                  break
                end
              end
            end

            board_has_bingo = false
          end
        end
      end

      def calculate_unmarked
        @boards_with_bingo.last.each do |line|
          line.reject { |n| n.values.first }.each { |h| @unmarked_sum += h.keys.first }
        end
      end
    end

    Part1.new.execute
    Part2.new.execute
  end
end

