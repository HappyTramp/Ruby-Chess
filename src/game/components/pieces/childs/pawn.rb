require_relative '../basic_piece'

# class of a Rook
class Pawn < BasicPiece
  attr_accessor :first_move

  def initialize(position, color, first_move=true)
    super(position, color)
    @first_move = first_move
  end

  def to_s
    @color == :w ? '♙' : '♟'
  end

  def get_possible_moves(board)
    pos_list = []
    x_mod = @color == :b ? 1 : -1
    pos_x_mod = @position[0] + x_mod

    cell_front = board[pos_x_mod, @position[1]]

    if get_cell_type(cell_front) == :empty
      pos_list << cell_front.position

      if @first_move
        cell_front_fm = board[pos_x_mod + x_mod, @position[1]]
        if get_cell_type(cell_front_fm) == :empty
          pos_list << cell_front_fm.position
        end
      end
    end

    [1, -1].each do |y_mod|
      cell_diag = board[pos_x_mod, @position[1] + y_mod]
      pos_list << cell_diag.position if get_cell_type(cell_diag) == :enemy
    end

    pos_list
  end
end
