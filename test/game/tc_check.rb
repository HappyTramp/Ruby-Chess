require 'game/check'
require 'game/index'
require 'game/components/pieces/index'
require_relative '../test_helper/h_moves'

describe Check, for: 'check' do
  describe '#is_in_check?' do
    let(:bishop_attack_white_g) { Game.new Board.new '8/8/2b2q2/2R5/3PK3/8/8/8' }
    let(:knight_attack_white_g) { Game.new Board.new '8/3b4/8/6n1/3PK3/8/8/8' }
    let(:queen_attack_black_g) { Game.new Board.new '8/3b4/8/3k4/8/3Q4/8/8' }
    let(:pawn_attack_black_g) { Game.new Board.new '8/8/4b3/3k4/4P3/4Q3/8/8' }
    it 'king is attacked -> true' do
      expect(bishop_attack_white_g.is_in_check?(:w)).to be true
      expect(knight_attack_white_g.is_in_check?(:w)).to be true
      expect(queen_attack_black_g.is_in_check?(:b)).to be true
      expect(pawn_attack_black_g.is_in_check?(:b)).to be true
    end
    
    let(:not_attacked_white_g) { Game.new Board.new '8/8/4b3/4r3/8/3KQ3/8/8' }
    let(:not_attacked_black_g) { Game.new Board.new '8/8/4b3/3k4/8/4Q3/8/8' }
    it 'king isnt attacked -> false' do
      expect(not_attacked_white_g.is_in_check?(:w)).to be false
      expect(not_attacked_black_g.is_in_check?(:b)).to be false
    end
  end

  describe '#is_checkmate?' do
    let(:checkmate_white_g) { Game.new Board.new '5RK1/5PPq/8/8/4b3/8/8/8' }
    let(:checkmate_black_g) { Game.new Board.new '8/8/8/7R/8/8/4Nppk/8' }
    let(:not_checkmate_white_g) { Game.new Board.new '4R1K1/5PPq/8/8/4b3/8/8/8' }
    let(:not_checkmate_black_g) { Game.new Board.new '8/8/8/7R/8/6p1/4Np1k/8' }

    it 'king checkmated -> true' do
      expect(checkmate_white_g.is_checkmate?(:w)).to be true
      expect(checkmate_black_g.is_checkmate?(:b)).to be true
    end
    
    it 'still legal move -> false' do
      expect(not_checkmate_white_g.is_checkmate?(:w)).to be false
      expect(not_checkmate_black_g.is_checkmate?(:b)).to be false
    end
  end

  describe '#legal_moves' do
    let(:move_king_white_g) { Game.new Board.new '8/8/3qr3/8/3K4/8/8/8' }
    let(:move_king_black_g) { Game.new Board.new '8/8/4k3/8/4QR2/8/8/8' }
    let(:take_piece_white_g) { Game.new Board.new '8/8/8/8/8/8/6qP/2r3bK' }
    let(:take_piece_black_g) { Game.new Board.new 'kN6/BQ6/2N5/8/8/8/8/8' }
    let(:block_white_g) { Game.new Board.new '8/8/8/4q3/Q7/3PKP2/3RNR2/8' }
    let(:block_black_g) { Game.new Board.new '2qbb3/2pkn3/7r/8/3R4/2Q1R3/8/8' }

    context 'in check' do
      it 'moves the king' do
        expect(move_king_white_g.legal_moves(:w)).to equal_move_array([
          [Piece::init(:K, [4, 3]), [5, 2]], [Piece::init(:K, [4, 3]), [4, 2]]
        ])
        expect(move_king_black_g.legal_moves(:b)).to equal_move_array([
          [Piece::init(:k, [2, 4]), [1, 3]], [Piece::init(:k, [2, 4]), [2, 3]]
        ])
      end
      it 'capture the piece wich is checking the king' do
        expect(take_piece_white_g.legal_moves(:w)).to equal_move_array([
          [Piece::init(:K, [7, 7]), [6, 6]]
        ])
        expect(take_piece_black_g.legal_moves(:b)).to equal_move_array([
          [Piece::init(:k, [0, 0]), [1, 1]]
        ])
      end
      it 'moves to block with ally piece' do
        expect(block_white_g.legal_moves(:w)).to equal_move_array([
          [Piece::init(:Q, [4, 0]), [4, 4]]
        ])
        expect(block_black_g.legal_moves(:b)).to equal_move_array([
          [Piece::init(:n, [1, 4]), [3, 3]], [Piece::init(:r, [2, 7]), [2, 3]]
        ])
      end
    end

    let(:pin_white_g) { Game.new Board.new '7K/7N/8/8/8/7q/8/8' }
    let(:pin_black_g) { Game.new Board.new '8/Q7/8/8/8/8/b7/k7' }
    it 'piece pined' do
      expect(pin_white_g.legal_moves(:w)).to equal_move_array([
        [Piece::init(:K, [0, 7]), [0, 6]], [Piece::init(:K, [0, 7]), [1, 6]]
      ])
      expect(pin_black_g.legal_moves(:b)).to equal_move_array([
        [Piece::init(:k, [7, 0]), [7, 1]], [Piece::init(:k, [7, 0]), [6, 1]]
      ])
    end
  end
end
