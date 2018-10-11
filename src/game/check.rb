require_relative '../helpers'
require_relative './components/pieces/childs/king'

module Check

  def is_in_check?(color)
    all_possible_moves(reverse_color(color)).each do |p|
      p[:possible_moves].each { |pos| return true if @board[*pos].is_a? King }
    end
    false
  end

  def is_checkmate?(color)
    legal_moves(color).length == 0
  end

  def legal_moves(color)
    legal_moves = []

    all_possible_moves(color).each do |p|
      p[:possible_moves].each do |m|
        position_origin = p[:piece].position
        move_square = @board[*m]

        @board.move_piece(p[:piece].position, m)
        legal_moves.push([p[:piece], m]) unless is_in_check?(color)
        @board.move_piece(m, position_origin)
        @board[*m] = move_square
      end
    end

    legal_moves
  end

end
