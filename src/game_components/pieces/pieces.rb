require_relative './chess_pieces/king'
require_relative './chess_pieces/queen'
require_relative './chess_pieces/rook'
require_relative './chess_pieces/knight'
require_relative './chess_pieces/bishop'
require_relative './chess_pieces/pawn'


module Piece
  King = King
  Queen = Queen
  Rook = Rook
  Knight = Knight
  Bishop = Bishop
  Pawn = Pawn

end


class EmptyCell

  attr_reader :position

  def initialize(position)
    @position = position
  end

  def nil?() true end

  def to_s() '' end
end
