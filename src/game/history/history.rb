require_relative '../../helper'
require_relative '../components/pieces/basic_piece'

# Game history
class History
  attr_reader :moves

  def initialize
    @moves = []
  end

  # add an entry to the moves list
  def add_entry(from, to, piece)
    # return unless History.correct_move?(move_infos)
    @moves << Move.new(from, to, piece)
  end

  # the last entry of the moves list
  def last_entry
    return Move.new(nil, nil, nil) if @moves.empty?

    @moves.last
  end

  # test if a move is correctly formated
  # def self.correct_move?(move)
  #   return false unless (Helper::in_border?(*move[:from]) &&
  #     Helper::in_border?(*move[:to]) &&
  #     move[:piece].is_a?(BasicPiece))

  #   true
  # end
end
