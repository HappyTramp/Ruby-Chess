require_relative '../helper'
require_relative './components/pieces/childs/king'
require_relative './history/history'

# check related method
module Check
  # detect if a color is in check -> the square of the king is controlled by the enemy
  def in_check?(enemy = false)
    all_normal_moves(!enemy, only_pos: true)
      .each { |p| return true if @board[*p].is_a?(King) }
    false
  end

  # detect if a color is checkmate(== no legal moves)
  def checkmate?(enemy = false)
    legal_moves(enemy).empty?
  end

  # filter the legal moves from all the possible moves
  # -> in check or a piece pined to the king
  def legal_moves(enemy = false)
    moves = []

    # do on all_moves instead of all_normal_moves
    # check each piece replacement for unknown promotion

    # can use #select on all_possible_moves
    all_normal_moves(enemy).each do |m|
      # - make the move
      # - test if it result in a self check
      # - undo the move
      m.make(@board, (enemy ? enemy_color : @turn_color))
      moves << m unless in_check?(enemy)
      m.make(@board, (enemy ? enemy_color : @turn_color), true)
    end

    moves
  end
end
