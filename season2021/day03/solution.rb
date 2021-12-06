module Season2021
  module Day03
    class << self
      def input
        File.read("#{__dir__}/input.txt").split
      end
    end

    class Part1
      def execute
        @input = Day03.input
        @epsilon = @gamma = 0
        calculate_gamma
        calculate_epsilon
        @consumption = @epsilon * @gamma

        puts "Day03, Part1, Result: #{@consumption}"
      end

      private

      def calculate_gamma
        gamma_binary = ''
        numbers_freequency = {}

        @input.each do |line|
          line.chars.each_with_index do |n, i|
            if numbers_freequency[i]
              if numbers_freequency[i][n]
                numbers_freequency[i][n] += 1
              else
                numbers_freequency[i][n] = 1
              end
            else
              numbers_freequency[i] = {n => 1}
            end
          end
        end

        numbers_freequency.each do |_index, frequency|
          gamma_binary += frequency['0'] > frequency['1'] ? '0' : '1'
        end

        @gamma = gamma_binary.to_i 2
      end

      def calculate_epsilon
        epsilon_binary = ''
        numbers_freequency = {}

        @input.each do |line|
          line.chars.each_with_index do |n, i|
            if numbers_freequency[i]
              if numbers_freequency[i][n]
                numbers_freequency[i][n] += 1
              else
                numbers_freequency[i][n] = 1
              end
            else
              numbers_freequency[i] = {n => 1}
            end
          end
        end

        numbers_freequency.each do |_index, frequency|
          epsilon_binary += frequency['0'] < frequency['1'] ? '0' : '1'
        end

        @epsilon = epsilon_binary.to_i 2
      end
    end

    class Part2
      def execute
        @input = Day03.input
        @co2 = @oxygen = 0
        calculate_oxygen
        calculate_co2
        @life_support = @oxygen * @co2

        puts "Day03, Part2, Result: #{@life_support}"
      end

      private

      def calculate_oxygen
        input = Day03.input
        i = 0
        input.first.size.times do
          tmp_input = input
          frequency = calculate_frequency tmp_input
          filter = frequency[i]['0'] > frequency[i]['1'] ? '0' : '1'
          tmp_input = tmp_input.select { |n| n[i] == filter }
          input = tmp_input
          i += 1
          break if tmp_input.size == 1
        end

        oxygen_binary = input.first
        @oxygen = oxygen_binary.to_i 2
      end

      def calculate_co2
        input = Day03.input
        i = 0
        input.first.size.times do
          tmp_input = input
          frequency = calculate_frequency tmp_input
          filter = frequency[i]['1'] < frequency[i]['0'] ? '1' : '0'
          tmp_input = tmp_input.select { |n| n[i] == filter }
          input = tmp_input
          i += 1
          break if tmp_input.size == 1
        end

        co2_binary = input.first
        @co2 = co2_binary.to_i 2
      end

      def calculate_frequency(input)
        numbers_freequency = {}

        input.each do |line|
          line.chars.each_with_index do |n, i|
            if numbers_freequency[i]
              if numbers_freequency[i][n]
                numbers_freequency[i][n] += 1
              else
                numbers_freequency[i][n] = 1
              end
            else
              numbers_freequency[i] = {n => 1}
            end
          end
        end

        numbers_freequency
      end
    end
  end
end

Season2021::Day03::Part1.new.execute
Season2021::Day03::Part2.new.execute
