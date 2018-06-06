require 'game_components/pieces/chess_pieces/pawn.rb'
require_relative '../../../testing_helper/h_board.rb'
require_relative '../../../testing_helper/h_piece.rb'

class Pawn; attr_accessor :first_move; end

describe Pawn, for: 'pawn' do
  describe '#get_possible_moves' do
    let(:white_start_pawn) { Pawn.new [6, 0], 'white' }
    let(:white_start_board) { tb_constructor(white_start_pawn) }
    it 'white start' do
      expect([white_start_board, white_start_pawn])
        .to contain_exact_positions([5, 0], [4, 0])
    end
    it 'white after first move' do
      white_start_pawn.first_move = false
      expect([white_start_board, white_start_pawn])
        .to contain_exact_positions([5, 0])
    end

    let(:black_start_pawn) { Pawn.new [1, 0], 'black' }
    let(:black_start_board) { tb_constructor(black_start_pawn) }
    it 'black start' do
      expect([black_start_board, black_start_pawn])
        .to contain_exact_positions([2, 0], [3, 0])
    end
    it 'black after first move' do
      black_start_pawn.first_move = false
      expect([black_start_board, black_start_pawn])
        .to contain_exact_positions([2, 0])
    end

    let(:std_white_pawn) { Pawn.new [4, 3], 'white', first_move: false }
    let(:std_white_tb_e_left) { tb_constructor(std_white_pawn, [3, 2]) }
    let(:std_white_tb_e_right) { tb_constructor(std_white_pawn, [3, 4]) }
    let(:std_white_tb_e_left_right_front) { tb_constructor(std_white_pawn, [3, 2], [3, 3], [3, 4]) }
    let(:std_white_tb_blocked) { tb_constructor(std_white_pawn, [3, 3]) }
    it 'can take enemy left and move up' do
      expect([std_white_tb_e_left, std_white_pawn])
        .to contain_exact_positions([3, 2], [3, 3])
    end
    it 'can take enemy right and move up' do
      expect([std_white_tb_e_right, std_white_pawn])
        .to contain_exact_positions([3, 3], [3, 4])
    end
    it 'can take enemy right and left' do
      expect([std_white_tb_e_left_right_front, std_white_pawn])
        .to contain_exact_positions([3, 2], [3, 4])
    end
    it 'is blocked' do
      expect([std_white_tb_blocked, std_white_pawn])
        .to contain_exact_positions
    end

    let(:std_black_pawn) { Pawn.new [3, 3], 'black', first_move: false }
    let(:std_black_tb_e_left) { tb_constructor(std_black_pawn, [4, 2]) }
    let(:std_black_tb_e_right) { tb_constructor(std_black_pawn, [4, 4]) }
    let(:std_black_tb_e_left_right_front) { tb_constructor(std_black_pawn, [4, 2], [4, 3], [4, 4]) }
    let(:std_black_tb_blocked) { tb_constructor(std_black_pawn, [4, 3]) }
    it 'can take enemy left and move up' do
      expect([std_black_tb_e_left, std_black_pawn])
        .to contain_exact_positions([4, 2], [4, 3])
    end
    it 'can take enemy right and move up' do
      expect([std_black_tb_e_right, std_black_pawn])
        .to contain_exact_positions([4, 3], [4, 4])
    end
    it 'can take enemy right and left' do
      expect([std_black_tb_e_left_right_front, std_black_pawn])
        .to contain_exact_positions([4, 2], [4, 4])
    end
    it 'is blocked' do
      expect([std_black_tb_blocked, std_black_pawn])
        .to contain_exact_positions
    end

    let(:corner_UL_pawn) { Pawn.new [0, 0], 'white', first_move: false }
    let(:corner_UL_tb) { in_corner(:up_left, corner_UL_pawn) }
    it { expect([corner_UL_tb, corner_UL_pawn]).to contain_exact_positions }

    let(:corner_DR_pawn) { Pawn.new [7, 7], 'black', first_move: false }
    let(:corner_DR_tb) { in_corner(:down_right, corner_DR_pawn) }
    it { expect([corner_DR_tb, corner_DR_pawn]).to contain_exact_positions }
  end
end
