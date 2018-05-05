# Basic Piece Class meant to be herited by the Real Pieces
class BasicPiece
  attr_reader :position

  def initialize(position)
    @position = position
  end
end
