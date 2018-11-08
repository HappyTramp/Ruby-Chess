require 'game/check'
require 'game/index'
require 'game/components/pieces/index'
require 'game/history/history'
require_relative '../test_helper/shortcut'

describe Check, for: 'check' do
  let(:Move) { History::Move }

  describe '#in_check?' do
    let(:bishop_attack_white_g) { Game.new Board.new '8/8/2b2q2/2R5/3PK3/8/8/8' }
    let(:knight_attack_white_g) { Game.new Board.new '8/3b4/8/6n1/3PK3/8/8/8'   }
    let(:queen_attack_black_g)  { Game.new Board.new '8/3b4/8/3k4/8/3Q4/8/8'    }
    let(:pawn_attack_black_g)   { Game.new Board.new '8/8/4b3/3k4/4P3/4Q3/8/8'  }
    let(:not_attacked_white_g)  { Game.new Board.new '8/8/4b3/4r3/8/3KQ3/8/8'   }
    let(:not_attacked_black_g)  { Game.new Board.new '8/8/4b3/3k4/8/4Q3/8/8'    }

    context 'when king is attacked' do
      it { expect(bishop_attack_white_g.in_check?(:w)).to be true }
      it { expect(knight_attack_white_g.in_check?(:w)).to be true }
      it { expect(queen_attack_black_g.in_check?(:b)).to be true  }
      it { expect(pawn_attack_black_g.in_check?(:b)).to be true   }
    end

    context 'when king is not attacked' do
      it { expect(not_attacked_white_g.in_check?(:w)).to be false }
      it { expect(not_attacked_black_g.in_check?(:b)).to be false }
    end
  end

  describe '#checkmate?' do
    let(:checkmate_white_g)     { Game.new Board.new '5RK1/5PPq/8/8/4b3/8/8/8'  }
    let(:checkmate_black_g)     { Game.new Board.new '8/8/8/7R/8/8/4Nppk/8'     }
    let(:not_checkmate_white_g) { Game.new Board.new '4R1K1/5PPq/8/8/4b3/8/8/8' }
    let(:not_checkmate_black_g) { Game.new Board.new '8/8/8/7R/8/6p1/4Np1k/8'   }

    context 'when is king checkmate' do
      it { expect(checkmate_white_g.checkmate?(:w)).to be true }
      it { expect(checkmate_black_g.checkmate?(:b)).to be true }
    end

    context 'when king is not checkmate' do
      it { expect(not_checkmate_white_g.checkmate?(:w)).to be false }
      it { expect(not_checkmate_black_g.checkmate?(:b)).to be false }
    end
  end

  describe '#legal_move' do
    let(:move_king_white_g)  { Game.new Board.new '8/8/3qr3/8/3K4/8/8/8'           }
    let(:move_king_black_g)  { Game.new Board.new '8/8/4k3/8/4QR2/8/8/8'           }
    let(:take_piece_white_g) { Game.new Board.new '8/8/8/8/8/8/6qP/2r3bK'          }
    let(:take_piece_black_g) { Game.new Board.new 'kN6/BQ6/2N5/8/8/8/8/8'          }
    let(:block_white_g)      { Game.new Board.new '8/8/8/4q3/Q7/3PKP2/3RNR2/8'     }
    let(:block_black_g)      { Game.new Board.new '2qbb3/2pkn3/7r/8/3R4/2Q1R3/8/8' }
    let(:pin_white_g)        { Game.new Board.new '7K/7N/8/8/8/7q/8/8'             }
    let(:pin_black_g)        { Game.new Board.new '8/Q7/8/8/8/8/b7/k7'             }

    context 'when the king need to move' do
      specify do
        expect(move_king_white_g.legal_move(:w)).to contain_exactly(
          sc_move(:K43to52),
          # sc_move(:K43to52),
          sc_move(:K43to42)
        )
      end
      specify do
        expect(move_king_black_g.legal_move(:b)).to contain_exactly(
          sc_move(:k24to13),
          sc_move(:k24to23)
        )
      end
    end

    context 'when the checking piece need to be captured' do
      specify do
        expect(take_piece_white_g.legal_move(:w))
          .to contain_exactly sc_move(:K77to66)
      end
      specify do
        expect(take_piece_black_g.legal_move(:b))
          .to contain_exactly sc_move(:k00to11)
      end
    end

    context 'when the check needs to be blocked with an ally piece' do
      specify do
        expect(block_white_g.legal_move(:w))
          .to contain_exactly sc_move(:Q40to44)
      end
      specify do
        expect(block_black_g.legal_move(:b)).to contain_exactly(
          sc_move(:n14to33),
          sc_move(:r27to23)
        )
      end
    end

    context 'with piece pined' do
      specify do
        expect(pin_white_g.legal_move(:w)).to contain_exactly(
          sc_move(:K07to06),
          sc_move(:K07to16)
        )
      end
      specify do
        expect(pin_black_g.legal_move(:b)).to contain_exactly(
          sc_move(:k70to71),
          sc_move(:k70to61)
        )
      end
    end
  end
end
