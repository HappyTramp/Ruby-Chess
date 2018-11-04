# BasicPiece Class meant to be inherited by the Real Pieces
class BasicPiece
  attr_accessor :position, :color

  # init the piece with a position and a color
  def initialize(position, color)
    @position = position
    @color = color
  end

  # EmptySquare return true to this method
  def empty?
    false
  end

  # filter the ally from the controlled square
  def possible_move(board)
    controlled_square(board).select { |p| board[*p].color != @color }
  end

  private

  # avoiding to repeat the #get_sides_of method
  def get_grouped_sides_of(board, *orientations)
    orientations.flat_map do |orientation|
      get_sides_of(board, orientation)
    end
  end

  # return both sides of a line ordered from @position
  def get_sides_of(board, orientation)
    line = {
      horizontal:    board.row(@position[0]),
      vertical:      board.column(@position[1]),
      diagonal:      board.diagonal(*@position),
      anti_diagonal: board.diagonal(*@position, anti: true)
    }[orientation]

    # split the line at the index of the piece
    index = line.index(self)
    [
      line.reverse[index == 0 ? line.length : -index, 7],
      line[index + 1, 7]
    ]
  end

  # filter a side to remove the square that arent accessible/controlled
  def filter_accessibility(side)
    filtered_side = []
    side.each do |square|
      case square_type(square)
      when :empty then filtered_side << square
      when :ally, :enemy then
        filtered_side << square
        break
      end
    end

    filtered_side
  end

  # identify a square type
  def square_type(square)
    return nil if square == false # out of border
    return :empty if square.empty?
    square.color == @color ? :ally : :enemy
  end
end
