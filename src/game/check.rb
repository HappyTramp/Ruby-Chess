require_relative '../helper'
require_relative './components/pieces/childs/king'
require_relative './history'

# check related method
module Check
  # detect if a color is in check -> the square of the king is controlled by the enemy
  def in_check?(color)
    all_possible_move(Helper::opposite_color(color),
                      only_position: true)
      .each { |p| return true if @board[*p].is_a?(King) }
    false
  end

  # detect if a color is checkmate(== no legal moves)
  def checkmate?(color)
    legal_move(color).empty?
  end

  # filter the legal moves from all the possible moves
  # -> in check or a piece pined to the king
  def legal_move(color)
    moves = []

    all_possible_move(color).each do |m|
      move_square = @board[*m.to]

      # make the move, test if it result in a self check, undo the move
      @board.move(m.from, m.to)
      moves << m unless in_check?(color)
      @board.move(m.to, m.from)
      @board[*m.to] = move_square
    end

    moves
  end
end
