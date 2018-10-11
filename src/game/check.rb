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
    return false unless is_in_check?(color)
    return true if filter_legal_moves().length == 0
    false
  end

  def filter_legal_moves(color)
    all_possible_moves(color).each do |p|
      p[:possible_moves].each do |pm|
        # si en échec après le coup -> false
      end
    end
  end

end
