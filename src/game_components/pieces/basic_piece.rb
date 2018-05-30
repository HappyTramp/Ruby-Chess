# Basic Piece Class meant to be herited by the Real Pieces
class BasicPiece

  attr_reader :position, :color

  # init the piece with a position and a color
  def initialize(position, color)
    @position = position
    @color = color
  end


  private

  # @returns two arrays of the cell left and right
  #          on the row where the piece is
  def horizontalCellsFromPosition(board)
    row = board.getRow(@position[0])
    
    left_side = row.reverse[-@position[1]..-1]
    right_side = row[-@position[1] - 1..-1]
    
    [left_side, right_side]    
  end
  
  # @returns two arrays of the cell up and bellow
  #          on the column where the piece is
  def verticalCellsFromPosition(board)
    column = board.getColumn(@position[1])

    up_side = column.reverse[-@position[0]..-1]
    bellow_side = column[-position[0] - 1..-1]

    [up_side, bellow_side]
  end

  # @returns the cell that are accessible from the piece position
  def filterSide(side)
    filtered_side = []
    
    for cell in side
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
