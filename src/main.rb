require_relative './game_components/board'
# require_relative './game_components/pieces/pieces'
# require_relative './../test/game_components/testing_helpers'

# board = TestingBoard.new rook_modified_positions: [[3, 3]], king_modified_positions: [[3, 1], [3, 5]], queenModifiedPositions: [[3, 0]]
# puts board

# out = board[3, 3].get_possible_moves(board)
# out.map! { |el| el.to_s }
# puts out.inspect

# r1 = [nil, Piece::King.new([3, 1], 'black'), nil]
# r2 = [nil, Piece::King.new([3, 1], 'black'), nil]

# puts piece_array_equal?(r1, r2)

if $PROGRAM_NAME == __FILE__
  b = Board.new
  puts b
end
