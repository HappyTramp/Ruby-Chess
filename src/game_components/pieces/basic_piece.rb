# Basic Piece Class meant to be inherited by the Real Pieces
class BasicPiece
  attr_reader :position, :color

  # init the piece with a position and a color
  def initialize(position, color)
    @position = position
    @color = color
  end

  private

  def get_grouped_sides_of(board, *orientations)
    puts orientations
    orientations.flat_map do |orientation|
      get_sides_of(board, orientation)
    end
  end

  def get_sides_of(board, orientation)
    line =
      case orientation
      when 'horizontal'    then board.get_row(@position[0])
      when 'vertical'      then board.get_column(@position[1])
      when 'diagonal'      then board.get_diagonal(*@position)
      when 'anti_diagonal' then board.get_diagonal(*@position, anti: true)
      else raise ArgumentError 'wrong orientation name'
      end

    case orientation
    when 'horizontal' then [
      line.reverse[@position[1] != 0 ? -@position[1] : 7, 7],
      line[@position[1] + 1..7]
    ]
    when 'vertical' then [
      line.reverse[@position[0] != 0 ? -@position[0] : 7, 7],
      line[@position[0] + 1..7]
    ]
    when 'diagonal' then [
      line[-line.index(self), 7],
      line.reverse[line.index(self) + 1..7]
    ]
    when 'anti_diagonal' then [
      line.reverse[-line.index(self), 7],
      line[line.index(self) + 1..7]
    ]
    end
  end

  # @returns the cell that are accessible from the piece position
  def filter_side(side)
    filtered_side = []

    side.each do |cell|
      case
      when cell.nil? then filtered_side << cell
      when cell.color == @color then break
      when cell.color != @color then
        filtered_side << cell
        break
      end
    end

    filtered_side
  end
end
