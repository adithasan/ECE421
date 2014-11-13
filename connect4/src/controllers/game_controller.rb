require 'test/unit'
require_relative '../models'

module Controllers
  class GameController
    include Test::Unit::Assertions

    def initialize(board, player, opponent)
      pre_initialize(board, player, opponent)
      @board = board
      @player = player
      @opponent = opponent
      invariant
    end

    def make_move(player)
      invariant
      pre_make_move(player)
      token, column = player.get_move(@board)
      @board[column] = token
      player.tokens[token] -= 1;
      post_make_move(player, token)
      invariant
    end

    private
    def pre_initialize(board, player, opponent)
      assert board.is_a? Models::Board
      assert player.is_a?  Models::Player
      assert opponent.is_a?  Models::Player
    end

    def pre_make_move(player)
      token_available = player.tokens.any? { |_, val| val > 0 }
      slot_available = @board.board.any? { |col| col.any? { |v| v.nil? } }
      assert token_available && slot_available
    end

    def post_make_move(player, token)
      assert player.tokens[token] >= 0
    end

    def invariant
      @player.tokens.all? do |key, val|
        assert key.respond_to? :to_sym
        assert val >= 0
      end
    end

  end

end