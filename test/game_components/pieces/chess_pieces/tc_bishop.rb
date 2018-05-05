require 'game_components/pieces/chess_pieces/bishop.rb'

describe Bishop do
  describe 'representation' do
    context 'black color' do
      it 'return a correct repr' do
        bishop = Bishop.new([0, 0], 'black')
        expect(bishop.to_s).to eql('♝')
      end
    end
    
    context 'white color' do
      it 'return a correct repr' do
        bishop = Bishop.new([0, 0], 'white')
        expect(bishop.to_s).to eql('♗')
      end
    end
  end

end
