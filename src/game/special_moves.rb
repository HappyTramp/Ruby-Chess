require_relative '../helpers.rb'

# apply edge case over the board
module SpecialMoves
  def pawn_promotion
    @board.get_row(0).each { |cell| return cell.position if cell.is_a? Pawn }
    @board.get_row(7).each { |cell| return cell.position if cell.is_a? Pawn }
    nil
  end

  # ni le roi ni la tour n'ont bougé
  # le roi n'est pas en échec
  # les cases sur lesquels il doit passer ne sont pas controlé par des pieces enemies
  # pas de piece entre le roi et la tour
  def castling
    #
  end

  def en_passant
  end
end
