require 'game/check'
require 'game/index'

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
  end

  describe '#filter_legal_moves' do
    let(:block_white_g) { Game.new Board.new '' }
    let(:block_black_g) { Game.new Board.new '' }
    let(:move_king_white_g) { Game.new Board.new '' }
    let(:move_king_black_g) { Game.new Board.new '' }
    let(:take_piece_white_g) { Game.new Board.new '' }
    let(:take_piece_black_g) { Game.new Board.new '' }

    it 'moves to block with ally piece' do

    end

    it 'moves the king' do

    end

    it 'capture the piece wich is checking the king' do

    end
  end
end
