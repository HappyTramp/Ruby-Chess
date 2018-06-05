require_relative '../../dev_helpers.rb'

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
    line =
      case orientation
      when 'horizontal'    then board.get_row(@position[0])
      when 'vertical'      then board.get_column(@position[1])
      when 'diagonal'      then board.get_diagonal(*@position)
      when 'anti_diagonal' then board.get_diagonal(*@position, anti: true)
      else raise ArgumentError 'wrong orientation name'
      end

    # on peut fusionner hor | ver et diag | antidiag.
    case orientation
    when 'horizontal' then [
      line.reverse[@position[1] != 0 ? -@position[1] : 7, 7],
      line[@position[1] + 1..7]
    ]
    when 'vertical' then [
      line.reverse[@position[0] != 0 ? -@position[0] : 7, 7],
      line[@position[0] + 1..7]
    ]
    when 'diagonal' then
      index = line.index(self)
      [
        line[index + 1..7],
        line.reverse[(index == 0 ? -1 : -index)..7]
      ]
    when 'anti_diagonal' then
      index = line.index(self)
      [
        line.reverse[(index == 0 ? -1 : -index), 7],
        line[index + 1..7]
      ]
    end
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

  def valid_cell?(cell)
    return false if cell == false

    case get_cell_type(cell)
    when :empty then true
    when :ally  then false
    when :enemy then true
    end
  end

  def get_cell_type(cell)
    case
    when cell.nil? then :empty
    when cell.color == @color then :ally
    when cell.color != @color then :enemy
    end
  end
end
