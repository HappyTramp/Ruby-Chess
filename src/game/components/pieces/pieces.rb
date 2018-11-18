require_relative './childs/king'
require_relative './childs/queen'
require_relative './childs/rook'
require_relative './childs/knight'
require_relative './childs/bishop'
require_relative './childs/pawn'

# Grouped pieces
module Pieces
  King = King
  Queen = Queen
  Rook = Rook
  Knight = Knight
  Bishop = Bishop
  Pawn = Pawn

  # initialize a piece with the associated letter and a position
  def self.init(type, position)
    color = (/[A-Z]/ =~ type).nil? ? :b : :w
    {
      K: King,
      Q: Queen,
      R: Rook,
      B: Bishop,
      N: Knight,
      P: Pawn
    }[type.upcase.to_sym].new position, color
  end
end

# An empty square that respond true to empty?
class EmptySquare
  attr_reader :position, :color

  def initialize(position)
    @position = position
    @color = nil
  end

  def empty?
    true
  end

  def ==(other)
    self.class == other.class &&
      @position == other.position
  end

  def to_s
    ' '
  end
end
