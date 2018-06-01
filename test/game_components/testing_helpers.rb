require_relative '../../src/game_components/board'

# Board class derivation for simpler testing purpose
class TestingBoard < Board
  def initialize(
    king_modified_positions: [],
    queen_modified_positions: [],
    rook_modified_positions: [],
    knight_modified_positions: [],
    bishop_modified_positions: [],
    pawn_modified_positions: [],
    normal_init: false
  )
    if normal_init
      super()
    else
      super(
        king_positions: king_modified_positions,
        queen_positions: queen_modified_positions,
        rook_positions: rook_modified_positions,
        knight_positions: knight_modified_positions,
        bishop_positions: bishop_modified_positions,
        pawn_positions: pawn_modified_positions
      )
    end
  end
end

# compare two instance of BasicPiece or nil
# @returns true if they are equal
def compare_pieces(piece1, piece2)
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
def piece_array_deep_equal(array1, array2)
  array1.zip(array2).each do |zip_elts|
    return false unless compare_pieces(*zip_elts)
  end

  true
end
