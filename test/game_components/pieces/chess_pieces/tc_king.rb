require 'game_components/pieces/chess_pieces/king.rb'
require_relative '../../../testing_helper/h_board.rb'
require_relative '../../../testing_helper/h_piece.rb'

describe King, for: 'king' do
  describe '#get_possible_moves' do
    let(:std_black_king) { King.new [3, 3], 'black' }
    let(:std_black_tb) { tb_constructor std_black_king, [2, 2], [3, 4], [4, 2], [4, 4] }
    it do
      expect([std_black_tb, std_black_king])
        .to contain_exact_positions([2, 3], [2, 4], [3, 2], [4, 2], [4, 3], [4, 4])
    end

    let(:std_white_king) { King.new [4, 3], 'white' }
    let(:std_white_tb) { tb_constructor std_white_king, [3, 2], [4, 4], [5, 2], [5, 4] }
    it do
      expect([std_white_tb, std_white_king])
        .to contain_exact_positions([3, 2], [4, 2], [3, 3], [3, 4], [5, 3])
    end

    let(:corner_UL_king) { King.new([0, 0], 'black') }
    let(:corner_UL_tb) { tb_constructor corner_UL_king, [1, 0] }
    it 'shouldnt fail' do
      expect { corner_UL_king.get_possible_moves(corner_UL_tb) }.to_not raise_error
      expect([corner_UL_tb, corner_UL_king]).to contain_exact_positions([0, 1], [1, 1])
    end

    let(:corner_DR_king) { King.new([7, 7], 'white') }
    let(:corner_DR_tb) { tb_constructor corner_DR_king, [6, 6] }
    it 'shouldnt fail' do
      expect { corner_DR_king.get_possible_moves(corner_DR_tb) }.to_not raise_error
      expect([corner_DR_tb, corner_DR_king]).to contain_exact_positions([7, 6], [6, 7])
    end
  end
end
