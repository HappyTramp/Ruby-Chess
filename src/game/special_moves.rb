require_relative '../helpers'
require_relative './components/pieces/childs/king'
require_relative './components/pieces/childs/rook'

# verify if special moves are applicable
module VerifySpecialMoves
  # detect if a pawn have reached the end of the board
  def can_pawn_promotion?
    @board.row(0).each { |s| return s.position if s.is_a? Pawn }
    @board.row(7).each { |s| return s.position if s.is_a? Pawn }
    false
  end

  # detect if a color can castle (short/long) with the following rules:
  # 1. king isnt in check
  # 2. king nor rook have moved 
  # 3. no piece between king and rook
  # 4. squares of the king move arent controlled by the enemy
  def can_castle?(color)
    no_castle = {short: false, long: false}
    possible_castle = {short: true, long: true}
  
    # 1.
    return no_castle if is_in_check?(color)

    # 2.
    short_rook_pos, long_rook_pos =
      color == :w ? [[7, 7], [7, 0]] : [[0, 7], [0, 0]]
    @history.moves.each do |m|
      next if m[:piece].color != color
      return no_castle if m[:piece].is_a? King
      possible_castle[:long] = false if m[:piece].is_a?(Rook) && m[:from] == long_rook_pos
      possible_castle[:short] = false if m[:piece].is_a?(Rook) && m[:from] == short_rook_pos
    end

    # 3.
    short_piece_square, long_piece_square =
      color == :w ? [[[7, 5], [7, 6]], [[7, 1], [7, 2], [7, 3]]]
      : [[[0, 5], [0, 6]], [[0, 1], [0, 2], [0, 3]]]
    short_piece_square.each do |pos|
      possible_castle[:short] = false unless @board[*pos].empty?
    end
    long_piece_square.each do |pos|
      possible_castle[:long] = false unless @board[*pos].empty?
    end

    # 4.
    short_check_square, long_check_square =
      short_piece_square, long_piece_square - (color == :w ? [7, 1] : [0, 1])
    all_controlled_square(opposite_color(color)).each do |c_square|
      c_square[:controlled_square].each do |p|
        possible_castle[:short] = false if short_check_square.include?(p)
        possible_castle[:long] = false if long_check_square.include?(p)
      end
    end

    possible_castle
  end

  # detect if a pawn can en passant an other one
  def can_en_passant?(color)
  end

end

# apply special moves
module ExecuteSpecialMoves

  def exec_pawn_promotion(position)
    
  end

  def exec_castle(color, side)
    
  end

  def exec_en_passant(from, to)
    
  end
end
