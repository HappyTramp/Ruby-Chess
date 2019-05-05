require 'game/components/pieces/pieces'
require_relative '../../../test_helper/h_piece'

describe Pieces, for: 'pieces' do
  describe '.init' do
    it { expect(Pieces::init(:k, [0, 0])).to eq Pieces::King.new([0, 0], :b)   }
    it { expect(Pieces::init(:q, [3, 3])).to eq Pieces::Queen.new([3, 3], :b)  }
    it { expect(Pieces::init(:p, [0, 1])).to eq Pieces::Pawn.new([0, 1], :b)   }
    it { expect(Pieces::init(:B, [4, 4])).to eq Pieces::Bishop.new([4, 4], :w) }
    it { expect(Pieces::init(:N, [0, 5])).to eq Pieces::Knight.new([0, 5], :w) }
  end

  describe '.fmt' do
    it { expect(Pieces::fmt('Ka4')).to eq Pieces::King.new([4, 0], :w)   }
    it { expect(Pieces::fmt('Pd2')).to eq Pieces::Pawn.new([6, 3], :w)   }
    it { expect(Pieces::fmt('Be3')).to eq Pieces::Bishop.new([5, 4], :w) }
    it { expect(Pieces::fmt('qd7')).to eq Pieces::Queen.new([1, 3], :b)  }
    it { expect(Pieces::fmt('rh8')).to eq Pieces::Rook.new([0, 7], :b)   }
  end

  describe '.fmt_array' do
    let(:rook_empty_pawn)   { [Pieces::fmt('Ra1'), EmptySquare.new([4, 4]), Pieces::fmt('p11')] }
    let(:king_queen_bishop) { [Pieces::fmt('ke8'), Pieces::fmt('qd8'), Pieces::fmt('bc8')]      }
    let(:pawn_pawn_empty)   { [Pieces::fmt('Pa2'), Pieces::fmt('Pb2'), EmptySquare.new([4, 0])] }
    let(:knight_king_king)  { [Pieces::fmt('nc5'), Pieces::fmt('kh6'), Pieces::fmt('kh7')]      }
    let(:more_pieces) do
      [Pieces::fmt('Ba4'), Pieces::fmt('Qe1'), Pieces::fmt('Be8'),
       Pieces::fmt('kg5'), Pieces::fmt('pg6'), EmptySquare.new([7, 0])]
    end

    it { expect(Pieces::fmt_array('Ra1 Ee4 p11')).to contain_exactly(*rook_empty_pawn)   }
    it { expect(Pieces::fmt_array('ke8 qd8 bc8')).to contain_exactly(*king_queen_bishop) }
    it { expect(Pieces::fmt_array('Pa2 Pb2 Ea4')).to contain_exactly(*pawn_pawn_empty)   }
    it { expect(Pieces::fmt_array('nc5 kh6 kh7')).to contain_exactly(*knight_king_king)  }
    it { expect(Pieces::fmt_array('Ba4 Qe1 Be8 kg5 pg6 Ea1')).to contain_exactly(*more_pieces) }
  end
end
