require 'game/check'
require 'game/game'
require 'game/components/pieces/pieces'
require 'game/history/history'
require_relative '../test_helper/shortcut'

describe Check, for: 'check' do
  let(:Move) { History::Move }

  describe '#in_check?' do
    let(:bishop_attack_white_g) { Game.new '8/8/2b2q2/2R5/3PK3/8/8/8 w' }
    let(:knight_attack_white_g) { Game.new '8/3b4/8/6n1/3PK3/8/8/8 w'   }
    let(:queen_attack_black_g)  { Game.new '8/3b4/8/3k4/8/3Q4/8/8 b'    }
    let(:pawn_attack_black_g)   { Game.new '8/8/4b3/3k4/4P3/4Q3/8/8 b'  }
    let(:not_attacked_white_g)  { Game.new '8/8/4b3/4r3/8/3KQ3/8/8 w'   }
    let(:not_attacked_black_g)  { Game.new '8/8/4b3/3k4/8/4Q3/8/8 b'    }

    context 'when king is attacked' do
      it { expect(bishop_attack_white_g.in_check?).to be true }
      it { expect(knight_attack_white_g.in_check?).to be true }
      it { expect(queen_attack_black_g.in_check?) .to be true }
      it { expect(pawn_attack_black_g.in_check?)  .to be true }
    end

    context 'when king is not attacked' do
      it { expect(not_attacked_white_g.in_check?).to be false }
      it { expect(not_attacked_black_g.in_check?).to be false }
    end
  end

  describe '#checkmate?' do
    let(:checkmate_white_g)     { Game.new '5RK1/5PPq/8/8/4b3/8/8/8 w'  }
    let(:checkmate_black_g)     { Game.new '8/8/8/7R/8/8/4Nppk/8 b'     }
    let(:not_checkmate_white_g) { Game.new '4R1K1/5PPq/8/8/4b3/8/8/8 w' }
    let(:not_checkmate_black_g) { Game.new '8/8/8/7R/8/6p1/4Np1k/8 b'   }

    context 'when is king checkmate' do
      it { expect(checkmate_white_g.checkmate?).to be true }
      it { expect(checkmate_black_g.checkmate?).to be true }
    end

    context 'when king is not checkmate' do
      it { expect(not_checkmate_white_g.checkmate?).to be false }
      it { expect(not_checkmate_black_g.checkmate?).to be false }
    end
  end

  describe '#legal_moves' do
    let(:move_king_white_g)  { Game.new '8/8/3qr3/8/3K4/8/8/8 w'           }
    let(:move_king_black_g)  { Game.new '8/8/4k3/8/4QR2/8/8/8 b'           }
    let(:take_piece_white_g) { Game.new '8/8/8/8/8/8/6qP/2r3bK w'          }
    let(:take_piece_black_g) { Game.new 'kN6/BQ6/2N5/8/8/8/8/8 b'          }
    let(:block_white_g)      { Game.new '8/8/8/4q3/Q7/3PKP2/3RNR2/8 w'     }
    let(:block_black_g)      { Game.new '2qbb3/2pkn3/7r/8/3R4/2Q1R3/8/8 b' }
    let(:pin_white_g)        { Game.new '7K/7N/8/8/8/7q/8/8 w'             }
    let(:pin_black_g)        { Game.new '8/Q7/8/8/8/8/b7/k7 b'             }

    context 'when the king need to move' do
      specify do
        expect(move_king_white_g.legal_moves).to contain_exactly(
          sc_move('K43>52'),
          sc_move('K43>42')
        )
      end
      specify do
        expect(move_king_black_g.legal_moves).to contain_exactly(
          sc_move('k24>13'),
          sc_move('k24>23')
        )
      end
    end

    context 'when the checking piece need to be captured' do
      specify do
        expect(take_piece_white_g.legal_moves)
          .to contain_exactly sc_move('K77>66')
      end
      specify do
        expect(take_piece_black_g.legal_moves)
          .to contain_exactly sc_move('k00>11')
      end
    end

    context 'when the check needs to be blocked with an ally piece' do
      it { expect(block_white_g.legal_moves).to contain_exactly sc_move('Q40>44') }
      specify do
        expect(block_black_g.legal_moves).to contain_exactly(
          sc_move('n14>33'),
          sc_move('r27>23')
        )
      end
    end

    context 'with piece pined' do
      specify do
        expect(pin_white_g.legal_moves).to contain_exactly(
          sc_move('K07>06'),
          sc_move('K07>16')
        )
      end
      specify do
        expect(pin_black_g.legal_moves).to contain_exactly(
          sc_move('k70>71'),
          sc_move('k70>61')
        )
      end
    end
  end
end
