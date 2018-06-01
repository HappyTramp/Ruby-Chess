require 'game_components/pieces/chess_pieces/king.rb'

describe King do
  describe 'representation' do
    context 'black color' do
      it 'return a correct repr' do
        king = King.new([0, 0], 'black')
        expect(king.to_s).to eql('♚')
      end
    end

    context 'white color' do
      it 'return a correct repr' do
        king = King.new([0, 0], 'white')
        expect(king.to_s).to eql('♔')
      end
    end
  end
end
