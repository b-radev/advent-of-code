module Season2021
  module Day21
    class << self
      def input
        @input ||= File.read("#{__dir__}/input.txt").split("\n")
      end
    end

    Player = Struct.new(:index, :score, :position)

    class Part1
      def initialize
        @players =
          Day21.input
               .map { _1.scan(/Player ([^,]+) starting position: ([^,]+)/).flatten }
               .map { Player.new _1.to_i, 0, _2.to_i }
      end

      def execute
        die = 0
        times = 0
        roll =
          lambda {
            die += 1
            times += 1
            die = 1 if die == 101
            return die
          }

        tripple_roll = -> { roll[] + roll[] + roll[] }

        result = 0
        loop do
          player = @players.shift
          @players.append player
          player.position += tripple_roll[]
          player.position -= 1
          player.position %= 10
          player.position += 1
          player.score += player.position
          if player.score >= 1000
            result = @players.first.score * times
            break
          end
        end

        puts "Day21, Part1, Result: #{result}"
      end
    end

    class Part2
      GameRound =
        Struct.new(:round, :players) do
          def next_rounds
            next_rounds = []

            [1, 2, 3].product([1, 2, 3], [1, 2, 3]).map(&:sum).each do |sum|
              updated_players =
                players.each_with_index.map do |player, index|
                  if index == round
                    player.dup.tap do |p|
                      p.position += sum
                      p.position -= 1
                      p.position %= 10
                      p.position += 1
                      p.score += p.position
                    end
                  else
                    player
                  end
                end

              next_rounds << GameRound.new((round + 1) % 2, updated_players)
            end

            next_rounds
          end

          def ended?
            players.any? { |player| player.score >= 21 }
          end
        end

      def initialize
        @players =
          Day21.input
               .map { _1.scan(/Player ([^,]+) starting position: ([^,]+)/).flatten }
               .map { Player.new _1.to_i, 0, _2.to_i }
      end

      def execute
        all_rounds = {}
        p1_win_rounds = []
        p2_win_rounds = []

        generate_rounds =
          lambda do |round|
            return all_rounds[round] if all_rounds.key?(round)

            all_rounds[round] = Hash.new(0)
            if round.ended?
              p1_win_rounds << round if round.players[0].score >= 21
              p2_win_rounds << round if round.players[1].score >= 21
            else
              round.next_rounds.each do |next_round|
                generate_rounds[next_round][round] += 1
              end
            end
            all_rounds[round]
          end

        generate_rounds[GameRound.new(0, @players)]

        cache = {}
        count_paths =
          lambda do |round|
            parents = generate_rounds[round]
            return 1 if parents.empty?

            cache[round] ||= parents.sum { |parent, count| count_paths[parent] * count }
          end

        result = [p1_win_rounds.sum(&count_paths), p2_win_rounds.sum(&count_paths)].max

        puts "Day21, Part2, Result: #{result}"
      end
    end

    # class GameRound
    #   attr_reader :round, :players

    #   def initialize(round, players)
    #     @round = round
    #     @players = players
    #   end

    #   def next_rounds
    #     next_rounds = []
    #     # Enumerator.new do |e|
    #       [1, 2, 3].product([1, 2, 3], [1, 2, 3]).map(&:sum).each do |sum|
    #         updated_players =
    #           @players.each_with_index.map do |player, index|
    #             if index == @round
    #               player.dup.tap do |p|
    #                 p.position += sum
    #                 p.position -= 1
    #                 p.position %= 10
    #                 p.position += 1
    #                 p.score += p.position
    #               end
    #             else
    #               player
    #             end
    #           end

    #         next_rounds << GameRound.new((@round + 1) % 2, updated_players)
    #       end

    #       next_rounds
    #     # end
    #   end

    #   def ended?
    #     @players.any? { |player| player.score >= 21 }
    #   end
    # end

    Part1.new.execute
    Part2.new.execute
  end
end
