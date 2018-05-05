require 'game_components/pieces/chess_pieces/queen.rb'

describe Queen do
  describe 'representation' do
    context 'black color' do
      it 'return a correct repr' do
        queen = Queen.new([0, 0], 'black')
        expect(queen.to_s).to eql('♛')
      end
    end
    
    context 'white color' do
      it 'return a correct repr' do
        queen = Queen.new([0, 0], 'white')
        expect(queen.to_s).to eql('♕')
      end
    end
  end

end
