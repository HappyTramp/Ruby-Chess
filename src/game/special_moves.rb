require_relative '../helpers'
require_relative './components/pieces/childs/king'
require_relative './components/pieces/childs/rook'

# verify edge case over the board
module VerifySpecialMoves
  def can_pawn_promotion?
    @board.get_row(0).each { |cell| return cell.position if cell.is_a? Pawn }
    @board.get_row(7).each { |cell| return cell.position if cell.is_a? Pawn }
    false
  end

  # ni le roi ni la tour n'ont bougé
  # le roi n'est pas en échec
  # les cases sur lesquels il doit passer ne sont pas controlé par des pieces enemies
  # pas de piece entre le roi et la tour
  def can_castle?(color)
    no_castle = {king_side: false, queen_side: false}
    possible_castle = {king_side: true, queen_side: true}
    return no_castle if is_in_check?(color)
    
    king_rook_pos, queen_rook_pos =
      color == :w ? [pos_nt(:h1), pos_nt(:a1)] : [pos_nt(:h8), pos_nt(:a8)]

    @history.moves.each do |m|
      next if m[:piece].color != color
      return no_castle if m[:piece].is_a? King
      possible_castle[:queen_side] = false if m[:piece].is_a?(Rook) && m[:from] == queen_rook_pos
      possible_castle[:king_side] = false if m[:piece].is_a?(Rook) && m[:from] == king_rook_pos
    end

    king_piece_square, queen_piece_square =
      color == :w ? [[pos_nt(:f1), pos_nt(:g1)], [pos_nt(:b1), pos_nt(:c1), pos_nt(:d1)]]
      : [[pos_nt(:f8), pos_nt(:g8)], [pos_nt(:b8), pos_nt(:c8), pos_nt(:d8)]]

    king_piece_square.each do |pos|
      possible_castle[:king_side] = false unless @board[*pos].empty?
    end
    queen_piece_square.each do |pos|
      possible_castle[:queen_side] = false unless @board[*pos].empty?
    end

    possible_castle
  end

  def can_en_passant?(color)
  end

end

# apply edge case over the board
module ExecuteSpecialMoves

  def exec_pawn_promotion(position)
    
  end

  def exec_castle(color, side)
    
  end

  def exec_en_passant(from, to)
    
  end
end
