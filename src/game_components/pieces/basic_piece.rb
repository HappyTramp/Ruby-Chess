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
  def horizontal_cells_from_position(board)
    row = board.get_row(@position[0])

    # /!\ in ruby, there is a difference between a[i, j] and a[i..j]
    # (https://devdocs.io/ruby~2.4/array#method-i-5B-5D)
    left_side = row.reverse[@position[1] != 0 ? -@position[1] : 7, 7]
    right_side = row[@position[1] + 1..7]

    [left_side, right_side]
  end

  # @returns two arrays of the cell up and bellow
  #          on the column where the piece is
  def vertical_cells_from_position(board)
    column = board.get_column(@position[1])

    up_side = column.reverse[@position[0] != 0 ? -@position[0] : 7, 7]
    down_side = column[@position[0] + 1..7]

    [up_side, down_side]
  end

  # @returns two arrays of cell up and down the cell
  #          in diagonal from the piece position
  def diagonal_cells_from_position(board)
    diagonal = board.get_diagonal(*@position)

    # it's a little mess but the test are clean, i swear
    # puts diagonal.to_s
    self_reached = false
    diag_up_side = []
    for cell in diagonal
      diag_up_side << cell if self_reached
      self_reached = true if cell == self
    end

    self_reached = false
    diag_down_side = []
    for cell in diagonal.reverse
      diag_down_side << cell if self_reached
      self_reached = true if cell == self
    end

    [diag_up_side, diag_down_side]
  end

  # @returns two arrays of cell up and down the cell
  #          in anti diagonal from the piece position
  def anti_diagonal_cells_from_position(board)
  #   anti_diagonal = board.get_anti_diagonal(*@position)

  #   self_reached = false
  #   anti_diag_up_side = []
  #   for cell in anti_diagonal.reverse
  #     anti_diag_up_side << cell if self_reached
  #     self_reached = true if cell == self
  #   end

  #   self_reached = false
  #   anti_diag_down_side = []
  #   for cell in anti_diagonal
  #     anti_diag_down_side << cell if self_reached
  #     self_reached = true if cell == self
  #   end

  #   [anti_diag_up_side, anti_diag_down_side]
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
