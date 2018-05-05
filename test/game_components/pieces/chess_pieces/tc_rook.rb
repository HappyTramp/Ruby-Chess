require 'game_components/pieces/chess_pieces/rook.rb'

describe Rook do
  describe 'representation' do
    context 'black color' do
      it 'return a correct repr' do
        rook = Rook.new([0, 0], 'black')
        expect(rook.to_s).to eql('♜')
      end
    end
    
    context 'white color' do
      it 'return a correct repr' do
        rook = Rook.new([0, 0], 'white')
        expect(rook.to_s).to eql('♖')
      end
    end
  end

end
