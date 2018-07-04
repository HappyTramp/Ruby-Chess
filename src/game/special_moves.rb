# apply edge case over the board
module SpecialMoves
  def pawn_promotion
    @board.get_row(0).each { |cell| return cell.position if cell.is_a? Pawn }
    @board.get_row(7).each { |cell| return cell.position if cell.is_a? Pawn }
    nil
  end

  def castling
    
  end

  def en_passant

  end
end
