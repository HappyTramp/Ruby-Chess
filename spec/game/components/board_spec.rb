require 'game/components/board'
require 'game/components/pieces/pieces'
require_relative '../../test_helper/h_board'
require_relative '../../test_helper/h_piece'
require_relative '../../test_helper/shortcut'

class Board; attr_accessor :grid; end

class ESquare
  def self.empty?
    true
  end
end

describe Board, for: 'board' do
  subject(:board) { Board.new }

  describe '#initialize' do
    let(:initial_grid) do
      [
        %i[r n b q k b n r].map.with_index { |n, i| Pieces::init(n, [0, i]) },
        (0..7).map { |i| Pieces::Pawn.new([1, i], :b) },
        *(Array.new(4) { Array.new(8) { ESquare } }),
        (0..7).map { |i| Pieces::Pawn.new([6, i], :w) },
        %i[R N B Q K B N R].map.with_index { |n, i| Pieces::init(n, [7, i]) }
      ]
    end

    context 'with default configuration' do
      it 'create a 8x8 board with pieces on their starting square' do
        board.grid.each.with_index do |row, i|
          expect(row).to equal_piece_array(initial_grid[i])
        end
      end
      it 'the rows are NOT from same instance' do
        board[0, 0] = true
        expect(board.grid[1][0]).not_to be true
      end
    end

    context 'with modified pieces configuration' do
      let(:m_board) { Board.new '8/8/4k3/2r5/3P4/8/8/8' }

      it { expect(m_board[2, 4]).to eq sc_piece(:k24) }
      it { expect(m_board[3, 2]).to eq sc_piece(:r32) }
      it { expect(m_board[4, 3]).to eq sc_piece(:P43) }
    end
  end

  describe '#[]' do
    it 'return the piece at the index' do
      expect(board[0, 0]).to eq sc_piece(:r00)
    end
    it 'return the empty square at the index' do
      expect(board[4, 0]).to be_empty
    end
  end

  describe '#[]=' do
    it 'set the square at the index to a piece' do
      board[0, 0] = sc_piece(:Q00)
      expect(board[0, 0]).to eq sc_piece(:Q00)
    end
    it 'set the square at the index to an empty square' do
      board[1, 1] = EmptySquare.new([1, 1])
      expect(board[1, 1]).to be_empty
    end
  end

  describe '#move' do
    before { board.move([0, 0], [1, 1]) }

    it 'moves a piece to a square and change its position' do
      expect(board[1, 1]).to eq sc_piece(:r11)
    end
    it 'empty the square where it was' do
      expect(board[0, 0]).to be_empty
    end
  end

  describe '#row' do
    it 'return the row at the index' do
      expect(board.row(0)).to eql(board.grid[0])
    end
  end

  describe '#column' do
    it 'return the col at the index' do
      expect(board.column(0)).to eql(board.grid.transpose[0])
    end
  end

  describe '#diagonal' do
    let(:diag33) do
      [Pieces::Pawn.new([6, 0], :w),
       ESquare, ESquare, ESquare, ESquare,
       Pieces::Pawn.new([1, 5], :b), Pieces::Knight.new([0, 6], :b)]
    end
    let(:diag52) do
      [Pieces::Rook.new([7, 0], :w), Pieces::Pawn.new([6, 1], :w),
       ESquare, ESquare, ESquare, ESquare,
       Pieces::Pawn.new([1, 6], :b), Pieces::Rook.new([0, 7], :b)]
    end
    let(:a_diag06) do
      [Pieces::Knight.new([0, 6], :b),
       Pieces::Pawn.new([1, 7], :b)]
    end
    let(:a_diag45) do
      [Pieces::Knight.new([0, 1], :b), Pieces::Pawn.new([1, 2], :b),
       ESquare, ESquare, ESquare, ESquare,
       Pieces::Pawn.new([6, 7], :w)]
    end

    context 'with diagonal (with arg anti: false)' do
      it { expect(board.diagonal(3, 3)).to equal_piece_array(diag33) }
      it { expect(board.diagonal(5, 2)).to equal_piece_array(diag52) }
    end

    context 'with anti diagonal (with arg anti: true)' do
      it { expect(board.diagonal(0, 6, anti: true)).to equal_piece_array(a_diag06) }
      it { expect(board.diagonal(4, 5, anti: true)).to equal_piece_array(a_diag45) }
    end
  end

  describe '#to_s' do
    subject(:board) { Board.new }

    let(:init_board_to_s) do
      "     a   b   c   d   e   f   g   h  \n"\
      "   ┌───┬───┬───┬───┬───┬───┬───┬───┐\n"\
      " 8 │ ♜ │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 7 │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 6 │   │   │   │   │   │   │   │   │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 5 │   │   │   │   │   │   │   │   │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 4 │   │   │   │   │   │   │   │   │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 3 │   │   │   │   │   │   │   │   │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 2 │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 1 │ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │\n"\
      "   └───┴───┴───┴───┴───┴───┴───┴───┘"
    end
    let(:piece_moved_board_to_s) do
      "     a   b   c   d   e   f   g   h  \n"\
      "   ┌───┬───┬───┬───┬───┬───┬───┬───┐\n"\
      " 8 │   │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 7 │ ♟ │ ♖ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 6 │   │   │   │   │   │   │   │   │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 5 │   │   │   │ ♚ │   │   │   │   │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 4 │   │   │   │   │   │   │   │   │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 3 │   │   │   │   │   │   │   │   │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 2 │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │\n"\
      "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
      " 1 │ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │\n"\
      "   └───┴───┴───┴───┴───┴───┴───┴───┘"
    end

    it 'initial configuration' do
      expect(board.to_s).to eq init_board_to_s
    end

    it 'return an accurate stringified grid according to the changes' do
      board[0, 0] = EmptySquare.new [0, 0]
      board[1, 1] = sc_piece(:R11)
      board[3, 3] = sc_piece(:k33)
      expect(board.to_s).to eq piece_moved_board_to_s
    end
  end
end
