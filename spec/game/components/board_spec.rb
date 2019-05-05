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
        (0..7).map { |i| Pieces::init(:p, [1, i]) },
        *(Array.new(4) { Array.new(8) { ESquare } }),
        (0..7).map { |i| Pieces::init(:P, [6, i]) },
        %i[R N B Q K B N R].map.with_index { |n, i| Pieces::init(n, [7, i]) }
      ]
    end

    context 'with default configuration' do
      it 'create a 8x8 board with pieces on their starting square' do
        board.grid.each.with_index do |row, i|
          expect(row).to equal_piece_array(initial_grid[i])
        end
      end
      it 'the rows arent from same instance' do
        board[0, 0] = true
        expect(board.grid[1][0]).not_to be true
      end
    end

    context 'with modified pieces configuration' do
      let(:m_board) { Board.new '8/8/4k3/2r5/3P4/8/8/8' }

      it { expect(m_board[2, 4]).to eq Pieces::init(:k, [2, 4]) }
      it { expect(m_board[3, 2]).to eq Pieces::init(:r, [3, 2]) }
      it { expect(m_board[4, 3]).to eq Pieces::init(:P, [4, 3]) }
    end
  end

  describe '#[]' do
    it { expect(board[0, 0]).to eq Pieces::init(:r, [0, 0]) }
    it { expect(board[7, 7]).to eq Pieces::init(:R, [7, 7]) }
    it { expect(board[1, 3]).to eq Pieces::init(:p, [1, 3]) }
    it { expect(board[3, 3]).to be_empty }
    it { expect(board[4, 0]).to be_empty }
  end

  describe '#[]=' do
    before do
      board[0, 0] = Pieces::init(:Q, [0, 0])
      board[4, 5] = Pieces::init(:p, [4, 5])
      board[7, 7] = Pieces::init(:k, [7, 7])
      board[1, 1] = EmptySquare.new([1, 1])
    end

    it { expect(board[0, 0]).to eq Pieces::init(:Q, [0, 0]) }
    it { expect(board[4, 5]).to eq Pieces::init(:p, [4, 5]) }
    it { expect(board[7, 7]).to eq Pieces::init(:k, [7, 7]) }
    it { expect(board[1, 1]).to be_empty }
  end

  describe '#get_at' do
    it { expect(board.get_at('a1')).to eq Pieces::fmt('Ra1') }
    it { expect(board.get_at('e1')).to eq Pieces::fmt('Ke1') }
    it { expect(board.get_at('h8')).to eq Pieces::fmt('rh8') }
    it { expect(board.get_at('e4')).to be_empty }
  end

  describe '#set_at' do
    before do
      board.set_at('e4', Pieces::fmt('Qe4'))
      board.set_at('h4', Pieces::fmt('Bh4'))
      board.set_at('a8', Pieces::fmt('ka8'))
      board.set_at('d3', Pieces::fmt('pd3'))
    end

    it { expect(board.get_at('e4')).to eq Pieces::fmt('Qe4') }
    it { expect(board.get_at('h4')).to eq Pieces::fmt('Bh4') }
    it { expect(board.get_at('a8')).to eq Pieces::fmt('ka8') }
    it { expect(board.get_at('d3')).to eq Pieces::fmt('pd3') }
  end

  describe '#move' do
    before do
      @rook_capture = board.move([0, 0], [1, 0])
      @bish_capture = board.move([7, 2], [6, 1])
    end

    it { expect(board[0, 0])  .to be_empty                    }
    it { expect(board[1, 0])  .to eq Pieces::init(:r, [1, 0]) }
    it { expect(@rook_capture).to eq Pieces::init(:p, [1, 0]) }
    it { expect(board[7, 2])  .to be_empty                    }
    it { expect(board[6, 1])  .to eq Pieces::init(:B, [6, 1]) }
    it { expect(@bish_capture).to eq Pieces::init(:P, [6, 1]) }
  end

  describe '#row' do
    (1..8).each { |i| it { expect(board.row(i)).to eq board.grid[i] } }
  end

  describe '#column' do
    (1..8).each { |j| it { expect(board.column(j)).to eq board.grid.transpose[j] } }
  end

  describe '#diagonal' do
    let(:main_diag)  { Pieces::fmt_array('Ra1 Pb2 Ec3 Ed4 Ee5 Ef6 pg7 rh8') }
    let(:h5_diag)    { Pieces::fmt_array('Qd1 Pe2 Ef3 Eg4 Eh5')             }
    let(:main_adiag) { Pieces::fmt_array('ra8 pb7 Ec6 Ed5 Ee4 Ef3 Pg2 Rh1') }
    let(:a6_adiag)   { Pieces::fmt_array('Ea6 Eb5 Ec4 Ed3 Pe2 Bf1')         }

    it { expect(board.diagonal(7, 0)).to eq main_diag }
    it { expect(board.diagonal(7, 3)).to eq h5_diag }
    it { expect(board.diagonal(0, 0, anti: true)).to eq main_adiag }
    it { expect(board.diagonal(2, 0, anti: true)).to eq a6_adiag }
  end

  describe '#to_s' do
    let(:board)   { Board.new }
    let(:m_board) { Board.new '1nbqkbnr/pRpppppp/8/3k4/8/8/PPPPPPPP/RNBQKBNR' }

    let(:board_to_s) do
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
    let(:m_board_to_s) do
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

    it { expect(board.to_s)  .to eq board_to_s   }
    it { expect(m_board.to_s).to eq m_board_to_s }
  end
end
