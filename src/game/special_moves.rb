require_relative '../helpers.rb'

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
    
  end

  def can_en_passant?(color)
  end

end

# apply edge case over the board
module ExecuteSpecialMoves

  def exec_pawn_promotion(position)
    
  end

  def exec_castle(color, direction)
    
  end

  def exec_en_passant(from, to)
    
  end
end
