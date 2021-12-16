module Season2021
  module Day16
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").strip
      end

      def bits
        @bits ||= input.each_char.map{'%04b' % _1.to_i(16)}.join
      end

    end

    class Solution
      def initialize
        @bits = Day16.bits
      end

      def execute
        @version_sum = 0
        result = read_packet @bits
        puts "Day16, Part1, Result: #{@version_sum}"
        puts "Day16, Part2, Result: #{result[0]}"
      end

      def read_packet(str, offset = 0)
        version = str[offset, 3].to_i(2)

        @version_sum += version
        offset += 3
        type = str[offset, 3].to_i(2)
        offset += 3

        if type == 4
          value_str = ''
          begin
            group = str[offset, 5]
            value_str << group[1, 4]
            offset += 5
          end while group[0] == '1'
          value = value_str.to_i(2)
        else
          length_type = str[offset, 1]
          offset += 1
          values = []
          if length_type == '0'
            bit_length = str[offset, 15].to_i(2)
            offset += 15
            target_offset = offset + bit_length
            while offset < target_offset
              child_value, offset = read_packet(str, offset)
              values << child_value
            end
          else
            chldren_count = str[offset, 11].to_i(2)
            offset += 11
            chldren_count.times do
              child_value, offset = read_packet(str, offset)
              values << child_value
            end
          end

          case type
          when 0
            value = values.sum
          when 1
            value = values.inject(1) { |prod, v| prod * v }
          when 2
            value = values.min
          when 3
            value = values.max
          when 5
            value = (values.first > values.last) ? 1 : 0
          when 6
            value = (values.first < values.last) ? 1 : 0
          when 7
            value = (values.first == values.last) ? 1 : 0
          end
        end

        [value, offset]
      end
    end

    Solution.new.execute
  end
end

