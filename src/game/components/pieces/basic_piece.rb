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

  def ==(other)
    other.class      == self.class &&
      other.position == @position  &&
      other.color    == @color
  end

  # filter the ally from the controlled square
  def possible_move(board)
    controlled_square(board).reject { |p| board[*p].color == @color }
  end

  private

  # avoiding to repeat the #sides method
  def grouped_sides(board, *orientations)
    orientations.flat_map do |orientation|
      sides(board, orientation)
    end
  end

  # return both sides of a line ordered from @position
  def sides(board, orientation)
    line =
      case orientation
      when :horizontal    then board.row(@position[0])
      when :vertical      then board.column(@position[1])
      when :diagonal      then board.diagonal(*@position)
      when :anti_diagonal then board.diagonal(*@position, anti: true)
      end

    # split the line at the index of the piece
    index = line.index(self)
    [
      line.reverse[index == 0 ? line.size : -index, 7],
      line[index + 1, 7]
    ]
  end

  # filter a side to remove the square that aren't accessible/controlled
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
