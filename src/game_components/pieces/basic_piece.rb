# Basic Piece Class meant to be herited by the Real Pieces
class BasicPiece
  attr_reader :position, :color

  def initialize(position, color=nil)
    @position = position
    @color = color
  end
end
