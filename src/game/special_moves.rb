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
    
    king_rook_pos, queen_rook_pos =
      color == :w ? [pos_nt(:h1), pos_nt(:a1)] : [pos_nt(:h8), pos_nt(:a8)]

    # 2.
    @history.moves.each do |m|
      next if m[:piece].color != color
      return no_castle if m[:piece].is_a? King
      possible_castle[:long] = false if m[:piece].is_a?(Rook) && m[:from] == queen_rook_pos
      possible_castle[:short] = false if m[:piece].is_a?(Rook) && m[:from] == king_rook_pos
    end

    # 3.
    king_piece_square, queen_piece_square =
      color == :w ? [[pos_nt(:f1), pos_nt(:g1)], [pos_nt(:b1), pos_nt(:c1), pos_nt(:d1)]]
      : [[pos_nt(:f8), pos_nt(:g8)], [pos_nt(:b8), pos_nt(:c8), pos_nt(:d8)]]

    king_piece_square.each do |pos|
      possible_castle[:short] = false unless @board[*pos].empty?
    end
    queen_piece_square.each do |pos|
      possible_castle[:long] = false unless @board[*pos].empty?
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
