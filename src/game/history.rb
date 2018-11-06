require_relative '../helpers'
require_relative './components/pieces/basic_piece'

# Game history
class History
  attr_reader :moves

  def initialize
    @moves = []
  end

  # add an entry to the moves list
  def add_entry(move)
    return unless History.correct_move?(move)
    @moves.push(move)
  end

  def last_entry
    return {piece: nil, from: nil, to: nil} if @moves.length == 0
    @moves.last
  end

  # test if a move is correctly formated
  def self.correct_move?(move)
    return false unless (index_in_border?(*move[:from]) &&
      index_in_border?(*move[:to]) &&
      move[:piece].is_a?(BasicPiece))
    true
  end
end
