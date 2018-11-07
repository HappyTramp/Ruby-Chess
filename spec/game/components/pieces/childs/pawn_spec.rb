require 'game/components/pieces/childs/pawn.rb'
require 'game/components/board.rb'
require_relative '../../../../test_helper/h_piece.rb'

describe Pawn, for: 'pawn' do
  describe '#possible_move' do
    let(:white_start_tb) { Board.new '8/8/8/8/8/8/P7/8' }
    let(:black_tb_full)    { Board.new '8/8/8/3p4/2PPP3/8/8/8' }
    let(:black_tb_e_right) { Board.new '8/8/8/3p4/4P3/8/8/8' }
    let(:black_tb_e_left)  { Board.new '8/8/8/3p4/2P5/8/8/8' }
    let(:black_start_tb) { Board.new '8/p7/8/8/8/8/8/8' }
    let(:white_tb_blocked) { Board.new '8/8/8/3p4/3P4/8/8/8' }
    let(:white_tb_full)    { Board.new '8/8/8/2ppp3/3P4/8/8/8' }
    let(:white_tb_e_right) { Board.new '8/8/8/4p3/3P4/8/8/8' }
    let(:white_tb_e_left)  { Board.new '8/8/8/2p5/3P4/8/8/8' }
    let(:black_tb_blocked) { Board.new '8/8/8/3p4/3P4/8/8/8' }

    context 'with the white pieces' do
      it 'white start -> can move 2 square in front of him' do
        expect([white_start_tb, white_start_tb[6, 0]]).to possible_move_position([5, 0], [4, 0])
      end
      it "white after a move -> can't move 2 square" do
        white_start_tb.move([6, 0], [5, 0])
        expect([white_start_tb, white_start_tb[5, 0]]).to possible_move_position([4, 0])
      end
      it 'can take enemy left and move up' do
        expect([white_tb_e_left, white_tb_e_left[4, 3]])
          .to possible_move_position([3, 2], [3, 3])
      end
      it 'can take enemy right and move up' do
        expect([white_tb_e_right, white_tb_e_right[4, 3]])
          .to possible_move_position([3, 3], [3, 4])
      end
      it 'can take enemy right and left' do
        expect([white_tb_full, white_tb_full[4, 3]])
          .to possible_move_position([3, 2], [3, 4])
      end
      it 'is blocked' do
        expect([white_tb_blocked, white_tb_blocked[4, 3]])
          .to possible_move_position
      end
    end

    context 'with the black pieces' do
      it 'black start -> can move 2 square in front of him' do
        expect([black_start_tb, black_start_tb[1, 0]]).to possible_move_position([2, 0], [3, 0])
      end
      it "black after move -> can't move 2 square" do
        black_start_tb.move([1, 0], [2, 0])
        expect([black_start_tb, black_start_tb[2, 0]]).to possible_move_position([3, 0])
      end

      it 'can take enemy left and move up' do
        expect([black_tb_e_left, black_tb_e_left[3, 3]])
          .to possible_move_position([4, 2], [4, 3])
      end
      it 'can take enemy right and move up' do
        expect([black_tb_e_right, black_tb_e_right[3, 3]])
          .to possible_move_position([4, 3], [4, 4])
      end
      it 'can take enemy right and left' do
        expect([black_tb_full, black_tb_full[3, 3]])
          .to possible_move_position([4, 2], [4, 4])
      end
      it 'is blocked' do
        expect([black_tb_blocked, black_tb_blocked[3, 3]])
          .to possible_move_position
      end
    end
  end

  describe '#controlled_square' do
    let(:white_piece_tb) { Board.new '8/8/8/2Q1k3/3P4/8/8/8' }
    let(:white_empty_tb) { Board.new '8/8/8/8/8/4P3/8/8' }
    let(:white_border_tb) { Board.new '8/8/8/8/P7/8/8/8' }
    let(:black_piece_tb) { Board.new '8/2p5/1q1R4/8/8/8/8/8' }
    let(:black_empty_tb) { Board.new '8/8/8/5p2/8/8/8/8' }
    let(:black_border_tb) { Board.new '8/8/8/7p/8/8/8/8' }

    it { expect([white_piece_tb, white_piece_tb[4, 3]]).to control_position([3, 2], [3, 4]) }
    it { expect([white_empty_tb, white_empty_tb[5, 4]]).to control_position([4, 3], [4, 5]) }
    it { expect([white_border_tb, white_border_tb[4, 0]]).to control_position([3, 1]) }

    it { expect([black_piece_tb, black_piece_tb[1, 2]]).to control_position([2, 1], [2, 3]) }
    it { expect([black_empty_tb, black_empty_tb[3, 5]]).to control_position([4, 4], [4, 6]) }
    it { expect([black_border_tb, black_border_tb[3, 7]]).to control_position([4, 6]) }
  end
end
