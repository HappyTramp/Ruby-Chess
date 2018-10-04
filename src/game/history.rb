require_relative '../helpers'
require_relative './components/pieces/basic_piece'

# Game history
class History
  def initialize
    @moves = []
  end

  def add_entry(move)
    return unless History.correct_move?(move)
    @moves.push(move)
  end

  # def search_entry(color, piece)
  #   @moves.each do |m|
  #     if m.color == color && m.piece == piece
  #       return m
  #     end
  #   end
  # end

  def self.correct_move?(move)
    return false unless (index_in_border?(*move[:from]) &&
      index_in_border?(*move[:to]) &&
      move[:piece].is_a?(BasicPiece))
    true
  end
end
