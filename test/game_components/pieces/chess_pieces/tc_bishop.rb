require 'game_components/pieces/chess_pieces/bishop.rb'

describe Bishop do
  describe 'representation' do
    context 'black color' do
      it 'return a correct repr' do
        expect(Bishop.new([0, 0], 'black').to_s).to eql('♝')
      end
    end

    context 'white color' do
      it 'return a correct repr' do
        expect(Bishop.new([0, 0], 'white').to_s).to eql('♗')
      end
    end
  end
end
