module Season2021
  module Day18
    class << self

      SNum = Struct.new :num, :brackets

      def input
        @input ||= File.read("#{__dir__}/input.txt").each_line.map{parse(_1)}
      end

      def parse(str)
        counter = 0
        output = []

        str.chars.each do |char|
          if char.match?(/\d/)
            output << SNum.new(char.to_i, counter)
          elsif char == "["
            counter += 1
          elsif char == "]"
            counter -= 1
          end
        end

        output
      end

      def explode(array, index)
        first, second = array.slice index, 2
        array[index - 1].num += first.num if index != 0
        array[index + 2].num += second.num if array[index + 2]
        array.delete_at index
        array[index] = SNum.new(0, (first.brackets - 1))
      end

      def split(array, index)
        array.insert(index + 1, SNum.new((array[index].num / 2.0).round, (array[index].brackets + 1)))
        array[index] = SNum.new((array[index].num / 2), (array[index].brackets + 1))
      end

      def add(a, b)
        joined = a.dup.concat(b).map{SNum.new(_1.num, _1.brackets + 1)}

        loop do
          index_to_explode = joined.index{_1.brackets >= 5}

          if index_to_explode
            explode joined, index_to_explode

            next
          end

          index_to_split = joined.index{_1.num >= 10}
          if index_to_split
            split joined, index_to_split

            next
          end

          break
        end

        joined
      end

      def magnitude(array)
        loop do
          max_brackets = array.map(&:brackets).max
          break if max_brackets == 0
          index = array.index{ _1.brackets == max_brackets}
          array[index] = SNum.new((3 * array[index].num + 2 * array[index + 1].num), (array[index].brackets - 1))
          array.delete_at(index + 1)
        end

        array.first.num
      end
    end

    class Solution
      def initialize
        @input = Day18.input
      end

      def execute
        result1 = Day18.magnitude(@input.reduce{Day18.add(_1, _2)})
        puts "Day18, Part1, Result: #{result1}"

        result2 = @input.permutation(2).map{|a, b| Day18.magnitude(Day18.add(a, b))}.max
        puts "Day18, Part2, Result: #{result2}"
      end
    end

    Solution.new.execute
  end
end

