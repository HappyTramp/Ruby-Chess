require_relative '../../user/analyse'
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
    color = type.to_s == type.to_s.upcase ? :w : :b
    {
      K: King,
      Q: Queen,
      R: Rook,
      B: Bishop,
      N: Knight,
      P: Pawn
    }[type.upcase.to_sym].new position, color
  end

  def self.fmt(str_piece)
    init(str_piece[0].to_sym, Analyse::notation_index(str_piece[1..2]))
  end

  def self.fmt_array(str_pieces)
    str_pieces.split.map do |p|
      if (p =~ /E[a-h][1-8]/).nil?
        fmt(p)
      else
        EmptySquare.new(Analyse::notation_index(p[1..3]))
      end
    end
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
