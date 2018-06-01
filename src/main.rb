require_relative './game_components/board'
require_relative './game_components/pieces/pieces'
require_relative '../test/game_components/testing_helpers'

# board = TestingBoard.new rookModifiedPositions: [[3, 3]], kingModifiedPositions: [[3, 1], [3, 5]], queenModifiedPositions: [[3, 0]]
# puts board

# out = board[3, 3].possibilitiesList(board)
# out.map! { |el| el.to_s }
# puts out.inspect

r1 = [EmptyCell.new([1, 1]), Piece::King.new([3, 1], 'black'), Piece::Rook.new([3, 4], 'white')]
r2 = [EmptyCell.new([1, 1]), Piece::King.new([3, 1], 'black'), Piece::Rook.new([3, 4], 'white')]

puts deepPieceArrayEqual(r1, r2)

b = Board.new
puts b
