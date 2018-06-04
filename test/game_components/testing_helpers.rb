require 'rspec/expectations'
require 'game_components/board'

# custom Board for testing purpose
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

# deeply compare two array of pieces.
RSpec::Matchers.define :equal_piece_array do |expected|
  match do |actual|
    expected.zip(actual).each do |zipped_pieces|
      return false unless pieces_equal?(*zipped_pieces)
    end
    true
  end

  failure_message do |actual|
    "expected: #{piece_array_pretty(expected)}\ngot: #{piece_array_pretty(actual)}"
  end

  def piece_array_pretty(piece_array)
    "[ #{piece_array.map { |el| el.nil? ? '*' : el.to_s }.join(', ')} ]"
  end
end

# compare two instance of BasicPiece or nil
def pieces_equal?(piece1, piece2)
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
