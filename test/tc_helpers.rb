require 'helpers'

describe 'Helpers', for: 'helpers' do
  describe '#pos_nt' do
    it { expect { pos_nt('a') }.to raise_error 'notation must be a sym' }
    it 'not correct syntax' do
      expect { pos_nt(:t5) }.to raise_error 'incorrect notation syntax'
      expect { pos_nt(:a9) }.to raise_error 'incorrect notation syntax'
    end
    it 'return an index' do
      expect(pos_nt(:a1)).to eql [0, 0]
      expect(pos_nt(:h8)).to eql [7, 7]
      expect(pos_nt(:h1)).to eql [0, 7]
      expect(pos_nt(:a8)).to eql [7, 0]
      expect(pos_nt(:e5)).to eql [4, 4]
    end
  end

  describe '#index_in_border?' do
    context 'out of borders indexes' do
      it { expect(index_in_border?(-1, 0)).to be false }
      it { expect(index_in_border?(0, -1)).to be false }
      it { expect(index_in_border?(8, 0)).to be false }
      it { expect(index_in_border?(0, 8)).to be false }
    end

    context 'in borders indexes' do
      it { expect(index_in_border?(0, 0)).to be true }
      it { expect(index_in_border?(7, 0)).to be true }
      it { expect(index_in_border?(0, 7)).to be true }
    end
  end

  describe '#reverse_color' do
    it { expect(reverse_color(:w)).to eql(:b) }
    it { expect(reverse_color(:b)).to eql(:w) }
  end
end
