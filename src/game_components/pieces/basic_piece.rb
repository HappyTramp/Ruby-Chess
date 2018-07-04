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
    orientations.flat_map do |orientation|
      get_sides_of(board, orientation)
    end
  end

  def get_sides_of(board, orientation)
    line = {
      horizontal:    board.get_row(@position[0]),
      vertical:      board.get_column(@position[1]),
      diagonal:      board.get_diagonal(*@position),
      anti_diagonal: board.get_diagonal(*@position, anti: true)
    }[orientation]

    index = line.index(self)
    [
      line.reverse[index == 0 ? -1 : -index, 7],
      line[index + 1, 7]
    ]
  end

  # @returns the cell that are accessible from the piece position
  def filter_side(side)
    filtered_side = []
    side.each do |cell|
      case get_cell_type(cell)
      when :empty then filtered_side << cell
      when :ally  then break
      when :enemy then
        filtered_side << cell
        break
      end
    end

    filtered_side
  end

  # is the cell type valid for a move
  def valid_cell?(cell)
    {
      empty: true,
      ally: false,
      enemy: true
    }[get_cell_type(cell)]
  end

  # identify a cell type
  def get_cell_type(cell)
    return nil if cell == false # out of border
    return :empty if cell.nil?
    cell.color == @color ? :ally : :enemy
  end
end
