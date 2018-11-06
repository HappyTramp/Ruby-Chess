require_relative '../helpers'
require_relative './components/pieces/childs/king'

module Check
  # detect if a color is in check -> the square of the king is controlled by the enemy
  def is_in_check?(color)
    all_possible_move(opposite_color(color)).each do |p|
      p[:possible_move].each do |p|
        return true if @board[*p].is_a?(King)
      end
    end
    false
  end

  # detect if a color is checkmate == no legal moves
  def is_checkmate?(color)
    legal_move(color).length == 0
  end

  # filter the legal moves from all the possible moves
  # -> in check or a piece pined to the king
  def legal_move(color)
    moves = []

    all_possible_move(color).each do |p|
      p[:possible_move].each do |m|
        position_origin = p[:piece].position
        move_square = @board[*m]

        # make the move, test if it result in a self check, undo the move
        @board.move(p[:piece].position, m)
        moves << [p[:piece], m] unless is_in_check?(color)
        @board.move(m, position_origin)
        @board[*m] = move_square
      end
    end

    moves
  end

end
