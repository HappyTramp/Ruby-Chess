require 'game_components/pieces/chess_pieces/knight.rb'

describe Knight do
  describe 'representation' do
    context 'black color' do
      it 'return a correct repr' do
        knight = Knight.new([0, 0], 'black')
        expect(knight.to_s).to eql('♞')
      end
    end

    context 'white color' do
      it 'return a correct repr' do
        knight = Knight.new([0, 0], 'white')
        expect(knight.to_s).to eql('♘')
      end
    end
  end
end
