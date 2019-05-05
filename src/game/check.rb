require_relative '../helper'
require_relative './components/pieces/childs/king'
require_relative './history/history'

# check related method
module Check
  # detect if a color is in check -> the square of the king is controlled by the enemy
  def in_check?(color)
    all_normal_moves(color == :w ? :b : :w, only_pos: true)
      .each { |p| return true if @board[*p].is_a?(King) }
    false
  end

  # detect if a color is checkmate (if she has no legal moves)
  def checkmate?(color)
    legal_moves(color).empty?
  end

  # filter the legal moves from all the possible moves
  # -> in check or a piece pined to the king
  def legal_moves(color)
    moves = []

    # do on all_moves instead of all_normal_moves
    # check each piece replacement for unknown promotion

    # can use #select on all_possible_moves
    all_moves(color).filter do |m|
      # - make the move
      # - test if it result in a self check
      # - undo the move
      m.make(@board)
      moves << m unless in_check?(enemy)
      m.make(@board, true)
    end

    moves
  end
end
