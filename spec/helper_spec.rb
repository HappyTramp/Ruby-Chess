require 'helper'

describe Helper, for: 'helper' do
  describe '.in_border?' do
    context 'when index is out of border' do
      it { expect(Helper::in_border?(-1, 0)).to be false }
      it { expect(Helper::in_border?(0, -1)).to be false }
      it { expect(Helper::in_border?(8, 0)).to be false }
      it { expect(Helper::in_border?(0, 8)).to be false }
    end

    context 'when index is in border' do
      it { expect(Helper::in_border?(0, 0)).to be true }
      it { expect(Helper::in_border?(7, 0)).to be true }
      it { expect(Helper::in_border?(0, 7)).to be true }
    end
  end

  describe '.opposite_color' do
    it { expect(Helper::opposite_color(:w)).to be(:b) }
    it { expect(Helper::opposite_color(:b)).to be(:w) }
  end
end
