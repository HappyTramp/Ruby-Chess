require 'game/components/pieces/childs/pawn.rb'
require 'game/components/board.rb'
require_relative '../../../../test_helper/h_piece.rb'

describe Pawn, for: 'pawn' do
  describe '#controlled_square' do
    let(:white_start_tb) { Board.new '8/8/8/8/8/8/P7/8' }
    it 'white start' do
      expect([white_start_tb, white_start_tb[6, 0]])
        .to contain_exact_positions([5, 0], [4, 0])
    end
    it 'white after first move' do
      white_start_tb[6, 0].first_move = false
      expect([white_start_tb, white_start_tb[6, 0]])
        .to contain_exact_positions([5, 0])
    end

    let(:black_start_tb) { Board.new '8/p7/8/8/8/8/8/8' }
    it 'black start' do
      expect([black_start_tb, black_start_tb[1, 0]])
        .to contain_exact_positions([2, 0], [3, 0])
    end
    it 'black after first move' do
      black_start_tb[1, 0].first_move = false
      expect([black_start_tb, black_start_tb[1, 0]])
        .to contain_exact_positions([2, 0])
    end

    let(:std_white_tb_e_left)  { Board.new '8/8/8/2p5/3P4/8/8/8' }
    let(:std_white_tb_e_right) { Board.new '8/8/8/4p3/3P4/8/8/8' }
    let(:std_white_tb_full)    { Board.new '8/8/8/2ppp3/3P4/8/8/8' }
    let(:std_white_tb_blocked) { Board.new '8/8/8/3p4/3P4/8/8/8' }
    it 'can take enemy left and move up' do
      std_white_tb_e_left[4, 3].first_move = false
      expect([std_white_tb_e_left, std_white_tb_e_left[4, 3]])
        .to contain_exact_positions([3, 2], [3, 3])
    end
    it 'can take enemy right and move up' do
      std_white_tb_e_right[4, 3].first_move = false
      expect([std_white_tb_e_right, std_white_tb_e_right[4, 3]])
        .to contain_exact_positions([3, 3], [3, 4])
    end
    it 'can take enemy right and left' do
      expect([std_white_tb_full, std_white_tb_full[4, 3]])
        .to contain_exact_positions([3, 2], [3, 4])
    end
    it 'is blocked' do
      expect([std_white_tb_blocked, std_white_tb_blocked[4, 3]])
        .to contain_exact_positions
    end

    let(:std_black_tb_e_left)  { Board.new '8/8/8/3p4/2P5/8/8/8' }
    let(:std_black_tb_e_right) { Board.new '8/8/8/3p4/4P3/8/8/8' }
    let(:std_black_tb_full)    { Board.new '8/8/8/3p4/2PPP3/8/8/8' }
    let(:std_black_tb_blocked) { Board.new '8/8/8/3p4/3P4/8/8/8' }
    it 'can take enemy left and move up' do
      std_black_tb_e_left[3, 3].first_move = false
      expect([std_black_tb_e_left, std_black_tb_e_left[3, 3]])
        .to contain_exact_positions([4, 2], [4, 3])
    end
    it 'can take enemy right and move up' do
      std_black_tb_e_right[3, 3].first_move = false
      expect([std_black_tb_e_right, std_black_tb_e_right[3, 3]])
        .to contain_exact_positions([4, 3], [4, 4])
    end
    it 'can take enemy right and left' do
      expect([std_black_tb_full, std_black_tb_full[3, 3]])
        .to contain_exact_positions([4, 2], [4, 4])
    end
    it 'is blocked' do
      expect([std_black_tb_blocked, std_black_tb_blocked[3, 3]])
        .to contain_exact_positions
    end

    let(:corner_UL_tb) { Board.new 'P7/8/8/8/8/8/8/8' }
    it { expect([corner_UL_tb, corner_UL_tb[0, 0]]).to contain_exact_positions }

    let(:corner_DR_tb) { Board.new '8/8/8/8/8/8/8/7p'  }
    it { expect([corner_DR_tb, corner_DR_tb[7, 7]]).to contain_exact_positions }
  end
end
