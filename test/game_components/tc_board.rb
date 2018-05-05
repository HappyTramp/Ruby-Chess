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
    ]
  ]

  
  describe '.initialize' do
    it 'create a 8x8 empty board (2D array)' do
      board.grid.each.with_index do |row, i|
        row.each.with_index do |cell, j|
          if !cell.nil?
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
  

  describe 'private methods' do
    describe '.isIndexInBoundarys?' do
      context 'out of boundarys indexs' do
        it 'return false' do
          expect(board.send :isIndexInBoundarys?, -1, 0)
            .to be false
          expect(board.send :isIndexInBoundarys?, 0, -1)
            .to be false
          expect(board.send :isIndexInBoundarys?, 8, 0)
            .to be false
          expect(board.send :isIndexInBoundarys?, 0, 8)
            .to be false
        end
      end
      
      context 'in boundarys indexs' do
        it 'return true' do
          expect(board.send :isIndexInBoundarys?, 0, 0)
            .to be true
          expect(board.send :isIndexInBoundarys?, 7, 0)
            .to be true
          expect(board.send :isIndexInBoundarys?, 0, 7)
            .to be true
        end
      end
    end
  end


  describe '.to_s' do
    board_repr_tc = Board.new
    context 'initial configuration' do
      it 'return stringify grid' do
        expect(board_repr_tc.to_s).to eql(
            "    a   b   c   d   e   f   g   h  
  ┌───┬───┬───┬───┬───┬───┬───┬───┐
 1│ ♜ │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 2│ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 3│   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 4│   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 5│   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 6│   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 7│ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 8│ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │
  └───┴───┴───┴───┴───┴───┴───┴───┘")
      end
    end

    context 'some pieces moved' do
      board_repr_tc2 = Board.new
      board_repr_tc2.grid[0][0] = nil
      board_repr_tc2.grid[1][1] = Piece::Rook.new [1, 1], 'white'
      board_repr_tc2.grid[3][3] = Piece::King.new [3, 3], 'black'
      it 'return an accurate stringify grid according to the changes' do
        expect(board_repr_tc2.to_s).to eql(
          "    a   b   c   d   e   f   g   h  
  ┌───┬───┬───┬───┬───┬───┬───┬───┐
 1│   │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 2│ ♟ │ ♖ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 3│   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 4│   │   │   │ ♚ │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 5│   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 6│   │   │   │   │   │   │   │   │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 7│ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │
  ├───┼───┼───┼───┼───┼───┼───┼───┤
 8│ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │
  └───┴───┴───┴───┴───┴───┴───┴───┘")
      end
    end
  end
end
