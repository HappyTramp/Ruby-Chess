require 'game_components/board.rb'
require 'game_components/pieces/pieces'
require_relative './testing_helpers.rb'

describe Board do
  describe '#initialize' do
    let(:initial_grid) do
      [
        [
          Piece::Rook.new([0, 0], 'black'), Piece::Knight.new([0, 1], 'black'),
          Piece::Bishop.new([0, 2], 'black'), Piece::Queen.new([0, 3], 'black'),
          Piece::King.new([0, 4], 'black'), Piece::Bishop.new([0, 5], 'black'),
          Piece::Knight.new([0, 6], 'black'), Piece::Rook.new([0, 7], 'black')
        ],
        (1..8).map.with_index { |_, i| Piece::Pawn.new([1, i], 'black') },
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        (1..8).map.with_index { |_, i| Piece::Pawn.new([6, i], 'white') },
        [
          Piece::Rook.new([7, 0], 'white'), Piece::Knight.new([7, 1], 'white'),
          Piece::Bishop.new([7, 2], 'white'), Piece::Queen.new([7, 3], 'white'),
          Piece::King.new([7, 4], 'white'), Piece::Bishop.new([7, 5], 'white'),
          Piece::Knight.new([7, 6], 'white'), Piece::Rook.new([7, 7], 'white')
        ]
      ]
    end
    context 'default configuration' do
      it 'create a 8x8 empty board (2D array)' do
        subject.grid.each.with_index do |row, i|
          expect(row).to equal_piece_array(initial_grid[i])
        end
      end
      it 'the rows are NOT from same instance' do
        subject.grid[0][0] = true
        expect(subject.grid[1][0]).to_not be true
      end
    end

    context 'modified pieces configuration' do
      it 'create a grid with the given positions' do
        modified_grid = Board.new(queen_positions: [[0, 0]], rook_positions: []).grid
        initial_grid.map! do |row|
          row.map! { |cell| [Piece::Queen, Piece::Rook].include?(cell.class) ? nil : cell }
        end
        initial_grid[0][0] = Piece::Queen.new [0, 0], 'black'

        modified_grid.each.with_index do |row, i|
          expect(row).to equal_piece_array(initial_grid[i])
        end
      end
    end
  end

  describe 'grid elements getter and setter' do
    describe '#[]' do
      context 'happy path' do
        it 'return a piece or nil if empty' do
          expect(subject[0, 0]).to equal_piece(Piece::Rook.new([0, 0], 'black'))
          expect(subject[6, 5]).to equal_piece(Piece::Pawn.new([6, 5], 'white'))
        end
        it 'return nil (EmptyCell) if the cell is empty' do
          expect(subject[4, 0]).to be_nil
          expect(subject[3, 3]).to be_nil
        end
      end
      context 'wrong index' do
        it 'return false' do
          expect(subject[-1, 0]).to be false
          expect(subject[0, 8]).to be false
        end
      end
    end

    describe '#[]=' do
      context 'happy path' do
        it 'set the cell to the given value' do
          subject[0, 0] = nil
          expect(subject.grid[0][0]).to be_nil
          test_piece = Piece::Queen.new [6, 2], 'black'
          subject[6, 2] = test_piece
          expect(subject.grid[6][2]).to equal_piece(test_piece)
        end
      end
      context 'wrong index' do
        it 'doesn\'t change anything' do
          subject_copy = subject.clone
          subject[-1, 0] = nil
          expect(subject_copy.grid).to eql subject.grid
          subject[0, 8] = nil
          expect(subject_copy.grid).to eql subject.grid
        end
      end
    end
  end

  describe '#get_row' do
    it 'return the correct row at the given index' do
      expect(subject.get_row(0)).to eql(subject.grid[0])
    end
  end
  describe '#get_column' do
    it 'return the correct col at the given index' do
      expect(subject.get_column(0)).to eql(subject.grid.transpose[0])
    end
  end

  describe '#get_diagonal' do
    let(:diagonal33) do
      [Piece::Pawn.new([6, 0], 'white'),
       nil, nil, nil, nil,
       Piece::Pawn.new([1, 5], 'black'), Piece::Knight.new([0, 6], 'black')]
    end
    let(:diagonal52) do
      [Piece::Rook.new([7, 0], 'white'), Piece::Pawn.new([6, 1], 'white'),
       nil, nil, nil, nil,
       Piece::Pawn.new([1, 6], 'black'), Piece::Rook.new([0, 7], 'black')]
    end
    let(:anti_diagonal06) do
      [Piece::Knight.new([0, 6], 'black'),
       Piece::Pawn.new([1, 7], 'black')]
    end
    let(:anti_diagonal45) do
      [Piece::Knight.new([0, 1], 'black'), Piece::Pawn.new([1, 2], 'black'),
       nil, nil, nil, nil,
       Piece::Pawn.new([6, 7], 'white')]
    end

    context 'diagonal (with arg anti = false)' do
      it 'with position [3, 3] return the diagonal that pass through it' do
        expect(subject.get_diagonal(3, 3))
          .to equal_piece_array(diagonal33)
      end
      it 'with position [5, 2] return the diagonal that pass through it' do
        expect(subject.get_diagonal(5, 2))
          .to equal_piece_array(diagonal52)
      end
    end

    context 'anti diagonal (with arg anti == true)' do
      it 'with position [0, 6] return the anti diagonal that pass through it' do
        expect(subject.get_diagonal(0, 6, anti: true))
          .to equal_piece_array(anti_diagonal06)
      end
      it 'with position [4, 5] return the anti diagonal that pass through it' do
        expect(subject.get_diagonal(4, 5, anti: true))
          .to equal_piece_array(anti_diagonal45)
      end
    end
  end

  describe 'private methods' do
    describe '#index_out_border?' do
      context 'out of borders indexes' do
        it 'return true' do
          expect(subject.send(:index_out_border?, -1, 0)).to be true
          expect(subject.send(:index_out_border?, 0, -1)).to be true
          expect(subject.send(:index_out_border?, 8, 0)).to be true
          expect(subject.send(:index_out_border?, 0, 8)).to be true
        end
      end

      context 'in borders indexes' do
        it 'return false' do
          expect(subject.send(:index_out_border?, 0, 0)).to be false
          expect(subject.send(:index_out_border?, 7, 0)).to be false
          expect(subject.send(:index_out_border?, 0, 7)).to be false
        end
      end
    end
  end

  describe '#to_s' do
    subject = Board.new
    context 'initial configuration' do
      it 'return stringified grid' do
        expect(subject.to_s).to eql(
          "     a   b   c   d   e   f   g   h\n"\
          "   ┌───┬───┬───┬───┬───┬───┬───┬───┐\n"\
          " 1 │ ♜ │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 2 │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 3 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 4 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 5 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 6 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 7 │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 8 │ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │\n"\
          "   └───┴───┴───┴───┴───┴───┴───┴───┘"
        )
      end
    end

    context 'some pieces moved' do
      it 'return an accurate stringified grid according to the changes' do
        subject.grid[0][0] = EmptyCell.new [0, 0]
        subject.grid[1][1] = Piece::Rook.new [1, 1], 'white'
        subject.grid[3][3] = Piece::King.new [3, 3], 'black'
        expect(subject.to_s).to eql(
          "     a   b   c   d   e   f   g   h\n"\
          "   ┌───┬───┬───┬───┬───┬───┬───┬───┐\n"\
          " 1 │   │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 2 │ ♟ │ ♖ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 3 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 4 │   │   │   │ ♚ │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 5 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 6 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 7 │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 8 │ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │\n"\
          "   └───┴───┴───┴───┴───┴───┴───┴───┘"
        )
      end
    end
  end
end
