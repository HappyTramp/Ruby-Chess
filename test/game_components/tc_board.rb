require 'game_components/board.rb'
require 'game_components/pieces/pieces'

describe Board do
  describe '.initialize' do
    board_init = Board.new
    initial_board = [
      [
        Piece::Rook.new([0, 0], 'black'),
        Piece::Knight.new([0, 1], 'black'),
        Piece::Bishop.new([0, 2], 'black'),
        Piece::Queen.new([0, 3], 'black'),
        Piece::King.new([0, 4], 'black'),
        Piece::Bishop.new([0, 5], 'black'),
        Piece::Knight.new([0, 6], 'black'),
        Piece::Rook.new([0, 7], 'black')
      ],
      (1..8).to_a.map.with_index { |_, i| Piece::Pawn.new([1, i], 'black') },
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      (1..8).to_a.map.with_index { |_, i| Piece::Pawn.new([6, i], 'white') },
      [
        Piece::Rook.new([7, 0], 'white'),
        Piece::Knight.new([7, 1], 'white'),
        Piece::Bishop.new([7, 2], 'white'),
        Piece::Queen.new([7, 3], 'white'),
        Piece::King.new([7, 4], 'white'),
        Piece::Bishop.new([7, 5], 'white'),
        Piece::Knight.new([7, 6], 'white'),
        Piece::Rook.new([7, 7], 'white')
      ]
    ]

    it 'create a 8x8 empty board (2D array)' do
      board_init.grid.each.with_index do |row, i|
        row.each.with_index do |cell, j|
          if !cell.nil?
            expect(cell.class).to eql(initial_board[i][j].class)
            expect(cell.position).to eql(initial_board[i][j].position)
            expect(cell.color).to eql(initial_board[i][j].color)
          end
        end
      end
    end

    it 'the rows are NOT from same instance' do
      board_init.grid[0][0] = true
      expect(board_init.grid[1][0]).to_not be true
    end
  end

  describe 'grid elements getter and setter' do
    board_get_set = Board.new

    describe '.[]' do
      context 'happy path' do
        it 'return a piece or nil if empty' do
          expect(board_get_set[0, 0]).to be_instance_of(Piece::Rook)
          expect(board_get_set[0, 0].position).to eql([0, 0])
          expect(board_get_set[0, 4]).to be_instance_of(Piece::King)
        end
        it 'return nil if the cell is empty' do
          expect(board_get_set[4, 0]).to be_nil
          expect(board_get_set[3, 3]).to be_nil
        end
      end
      context 'wrong index' do
        it 'return false' do
          expect(board_get_set[-1, 0]).to be false
          expect(board_get_set[0, 8]).to be false
        end
      end
    end
    
    describe '.[]=' do
      context 'happy path' do
        it 'set the cell to the given value' do
          board_get_set[0, 0] = nil
          expect(board_get_set.grid[0][0]).to be_nil
          board_get_set[1, 1] = Piece::Queen.new [1, 1], 'black'
          expect(board_get_set.grid[1][1]).to be_instance_of(Piece::Queen)
        end
      end
      context 'wrong index' do
        it 'doesn\'t change anything' do
          board_get_set_copy = board_get_set.clone
          board_get_set[-1, 0] = nil
          expect(board_get_set_copy.grid).to eql board_get_set.grid
          
          board_get_set_copy2 = board_get_set.clone
          board_get_set[0, 8] = nil
          expect(board_get_set_copy.grid).to eql board_get_set.grid
        end
      end
    end
  end
  

  describe 'private methods' do
    board_private = Board.new
    describe '.isIndexOutBoundarys?' do
      context 'out of boundarys indexs' do
        it 'return true' do
          expect(board_private.send :isIndexOutBoundarys?, -1, 0)
            .to be true
          expect(board_private.send :isIndexOutBoundarys?, 0, -1)
            .to be true
          expect(board_private.send :isIndexOutBoundarys?, 8, 0)
            .to be true
          expect(board_private.send :isIndexOutBoundarys?, 0, 8)
            .to be true
        end
      end
      
      context 'in boundarys indexs' do
        it 'return false' do
          expect(board_private.send :isIndexOutBoundarys?, 0, 0)
            .to be false
          expect(board_private.send :isIndexOutBoundarys?, 7, 0)
            .to be false
          expect(board_private.send :isIndexOutBoundarys?, 0, 7)
            .to be false
        end
      end
    end
  end


  describe '.to_s' do
    board_repr_tc = Board.new
    context 'initial configuration' do
      it 'return stringify grid' do
        expect(board_repr_tc.to_s).to eql(
            "    a   b   c   d   e   f   g   h  \n"\
            "  ┌───┬───┬───┬───┬───┬───┬───┬───┐\n"\
            " 1│ ♜ │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │\n"\
            "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
            " 2│ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │\n"\
            "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
            " 3│   │   │   │   │   │   │   │   │\n"\
            "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
            " 4│   │   │   │   │   │   │   │   │\n"\
            "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
            " 5│   │   │   │   │   │   │   │   │\n"\
            "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
            " 6│   │   │   │   │   │   │   │   │\n"\
            "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
            " 7│ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │\n"\
            "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
            " 8│ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │\n"\
            "  └───┴───┴───┴───┴───┴───┴───┴───┘")
      end
    end

    context 'some pieces moved' do
      board_repr_tc2 = Board.new
      board_repr_tc2.grid[0][0] = nil
      board_repr_tc2.grid[1][1] = Piece::Rook.new [1, 1], 'white'
      board_repr_tc2.grid[3][3] = Piece::King.new [3, 3], 'black'
      it 'return an accurate stringify grid according to the changes' do
        expect(board_repr_tc2.to_s).to eql(
          "    a   b   c   d   e   f   g   h  \n"\
          "  ┌───┬───┬───┬───┬───┬───┬───┬───┐\n"\
          " 1│   │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │\n"\
          "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 2│ ♟ │ ♖ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │\n"\
          "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 3│   │   │   │   │   │   │   │   │\n"\
          "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 4│   │   │   │ ♚ │   │   │   │   │\n"\
          "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 5│   │   │   │   │   │   │   │   │\n"\
          "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 6│   │   │   │   │   │   │   │   │\n"\
          "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 7│ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │\n"\
          "  ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 8│ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │\n"\
          "  └───┴───┴───┴───┴───┴───┴───┴───┘")
      end
    end
  end
end
