require_relative '../../src/game_components/board'


# Board class derivation for simpler testing purpose
class TestingBoard < Board

  def initialize(
    kingModifiedPositions: [],
    queenModifiedPositions: [],
    rookModifiedPositions: [],
    knightModifiedPositions: [],
    bishopModifiedPositions: [],
    pawnModifiedPositions: [],
    normalInit: false
  )
    unless normalInit
      super(
        kingPositions: kingModifiedPositions,
        queenPositions: queenModifiedPositions,
        rookPositions: rookModifiedPositions,
        knightPositions: knightModifiedPositions,
        bishopPositions: bishopModifiedPositions,
        pawnPositions: pawnModifiedPositions
      )
    else
      super()
    end
  end
end


# compare two instance of BasicPiece or nil
# @returns true if they are equal
def comparePieces(piece1, piece2)
  return true if piece1.nil? && piece2.nil?
  return false if piece1.nil? || piece2.nil?

  if piece1.class.superclass == BasicPiece && piece2.class.superclass == BasicPiece
    if piece1.class == piece2.class &&
       piece1.color == piece2.color &&
       piece1.position == piece2.position
      return true
    end
  end

  false
end


# deeply compare two array of pieces.
# @returns true if they are deep equal
def pieceArrayDeepEqual(array1, array2)
  array1.zip(array2).each do |zip_elts|
    return false unless comparePieces(*zip_elts)
  end

  true
end
