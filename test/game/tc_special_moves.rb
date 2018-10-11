require 'game/index'
require 'game/special_moves'


describe VerifySpecialMoves, for: 'special_moves' do
  describe '#can_pawn_promotion?' do
    let(:no_promo_g) { Game.new Board.new('8/8/8/3k4/8/8/8/8') }
    it { expect(no_promo_g.can_pawn_promotion?).to be false }
    let(:promo_white_g) { Game.new Board.new('3P4/8/8/8/8/8/8/8') }
    it { expect(promo_white_g.can_pawn_promotion?).to eql([0, 3]) }
    let(:promo_black_g) { Game.new Board.new('8/8/8/8/8/8/8/3p4') }
    it { expect(promo_black_g.can_pawn_promotion?).to eql([7, 3]) }
  end

  describe '#can_castle?' do
    let(:in_check_white_g) { Game.new Board.new('8/8/8/4q3/8/8/8/R3K2R') }
    let(:in_check_black_g) { Game.new Board.new('r3k2r/8/8/4Q3/8/8/8/8') }
    let(:cast_controlled_white_g) { Game.new Board.new('8/8/8/8/8/2r2r2/8/R3K2R') }
    let(:cast_controlled_black_g) { Game.new Board.new('r3k2r/8/3R2R1/8/8/8/8/8') }
    let(:piece_between_white_g) { Game.new Board.new '8/8/8/8/8/8/8/R2QK1NR' }
    let(:piece_between_black_g) { Game.new Board.new 'r2bk1nr/8/8/8/8/8/8/8' }
    let(:king_moved_white_g) { Game.new Board.new('8/8/8/8/8/8/8/R3K2R') }
    let(:king_moved_black_g) { Game.new Board.new('r3k2r/8/8/8/8/8/8/8') }
    let(:rook_moved_white_g) { Game.new Board.new('8/8/8/8/8/8/8/R3K2R') }
    let(:rook_moved_black_g) { Game.new Board.new('r3k2r/8/8/8/8/8/8/8') }
    let(:right_condition_white_g) { Game.new Board.new('8/8/8/8/8/8/8/R3K2R') }
    let(:right_condition_black_g) { Game.new Board.new('r3k2r/8/8/8/8/8/8/8') }


    it 'false if king in check' do

    end
    it 'false if castling square are controlled by the enemy' do
  
    end

    it 'false if piece between the king and rook' do

    end

    it 'false if king as moved before' do

    end

    it 'false if rook as moved before' do

    end

    it 'true if all condition are right' do
    end
  end

  describe '#can_en_passant?' do

  end
end

describe ExecuteSpecialMoves do
  describe '#exec_pawn_promotion' do
    
  end

  describe '#exec_castle' do
    
  end

  describe '#exec_en_passant' do
    
  end
end
