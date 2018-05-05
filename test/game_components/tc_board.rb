require 'game_components/board.rb'
require 'game_components/pieces/pieces'

describe Board do
  board = Board.new
  initial_board = [
    [
      Piece::Rook.new([0, 0]),
      Piece::Knight.new([0, 1]),
      Piece::Bishop.new([0, 2]),
      Piece::Queen.new([0, 3]),
      Piece::King.new([0, 4]),
      Piece::Bishop.new([0, 5]),
      Piece::Knight.new([0, 6]),
      Piece::Rook.new([0, 7])
    ],
    (1..8).to_a.map.with_index { |_, i| Piece::Pawn.new([1, i]) },
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    (1..8).to_a.map.with_index { |_, i| Piece::Pawn.new([6, i]) },
    [
      Piece::Rook.new([7, 0]),
      Piece::Knight.new([7, 1]),
      Piece::Bishop.new([7, 2]),
      Piece::Queen.new([7, 3]),
      Piece::King.new([7, 4]),
      Piece::Bishop.new([7, 5]),
      Piece::Knight.new([7, 6]),
      Piece::Rook.new([7, 7])
    ],
  ]

  describe '.initialize' do
    it 'create a 8x8 empty board (2D array)' do
      board.grid.each.with_index do |row, i|
        row.each.with_index do |cell, j|
          unless cell.nil?
            expect(cell.class).to eql(initial_board[i][j].class)
            expect(cell.position).to eql(initial_board[i][j].position)
          end
        end
      end
    end

    it 'the rows are NOT from same instance' do
      board.grid[0][0] = true
      expect(board.grid[1][0]).to_not be true
    end
  end
end
