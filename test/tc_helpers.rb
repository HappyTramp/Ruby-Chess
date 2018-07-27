require 'helpers'

describe 'Helpers' do
  describe '#nt' do
    it { expect { nt('a') }.to raise_error 'notation must be a sym' }
    it 'not correct syntax' do
      expect { nt(:t5) }.to raise_error 'incorrect notation syntax'
      expect { nt(:a9) }.to raise_error 'incorrect notation syntax'
    end
    it 'return an index' do
      expect(nt(:a1)).to eql [0, 0]
      expect(nt(:h8)).to eql [7, 7]
      expect(nt(:h1)).to eql [0, 7]
      expect(nt(:a8)).to eql [7, 0]
      expect(nt(:e5)).to eql [4, 4]
    end
  end
end
