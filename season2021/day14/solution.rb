module Season2021
  module Day14
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").chomp
      end

      def template_and_instructions
        template, instruction_lines = input.split("\n\n")
        template = template.strip.chars

        instructions = {}
        instruction_lines.each_line do |line|
          pair, insertable = line.split(' -> ').map(&:strip)
          instructions[[pair[0], pair[1]]] = insertable
        end

        [template, instructions]
      end

      def result(element_counts, template)
        element_occurances = Hash.new(0)
        element_counts.each_pair do |pair, count|
          element_occurances[pair.first] += count
        end
        element_occurances[template[-1]] += 1
        element_occurances.values.max - element_occurances.values.min
      end

      def element_counts(amount, template, instructions)
        element_counts = Hash.new(0)
        template.each_cons(2) { element_counts[[_1, _2]] += 1 }

        amount.times do
          old = element_counts.dup
          element_counts = Hash.new(0)
          old.each do |(a, b), v|
            found = instructions[[a, b]]
            element_counts[[a, found]] += v
            element_counts[[found, b]] += v
          end
        end

        element_counts
      end
    end

    class Part1
      def initialize
        @template, @instructions = Day14.template_and_instructions
      end

      def execute
        element_counts = Day14.element_counts 10, @template, @instructions

        result = Day14.result element_counts, @template

        puts "Day14, Part1, Result: #{result}"
      end
    end

    class Part2
      def initialize
        @template, @instructions = Day14.template_and_instructions
      end

      def execute
        element_counts = Day14.element_counts 40, @template, @instructions

        result = Day14.result element_counts, @template

        puts "Day14, Part2, Result: #{result}"
      end
    end


    Part1.new.execute
    Part2.new.execute
  end
end

