require_relative './game/components/board'
# require_relative './game.rb'
# require_relative './game/components/pieces/index'
# require_relative './../test/game/components/testing_helpers'

# board = TestingBoard.new rook_modified_positions: [[3, 3]], king_modified_positions: [[3, 1], [3, 5]], queenModifiedPositions: [[3, 0]]
# puts board

# out = board[3, 3].controlled_square(board)
# out.map! { |el| el.to_s }
# puts out.inspect

# r1 = [nil, Pieces::King.new([3, 1], :b), nil]
# r2 = [nil, Pieces::King.new([3, 1], :b), nil]

# puts piece_array_equal?(r1, r2)

b = Board.new 
puts b

# g = Game.new
# g.compute_all_possible_moves
