require 'game_components/pieces/chess_pieces/pawn.rb'

describe Pawn do
  describe 'representation' do
    context 'black color' do
      it 'return a correct repr' do
        pawn = Pawn.new([0, 0], 'black')
        expect(pawn.to_s).to eql('♟')
      end
    end
    
    context 'white color' do
      it 'return a correct repr' do
        pawn = Pawn.new([0, 0], 'white')
        expect(pawn.to_s).to eql('♙')
      end
    end
  end

end
