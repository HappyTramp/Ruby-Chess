require 'game_components/pieces/basic_piece'

describe BasicPiece do
  describe '.initialize' do
    basic_piece = BasicPiece.new([0, 0], 'black')

    describe 'position attr' do
      context 'with the position [0, 0]' do

        it 'has the right position param' do
          expect(basic_piece.position).to eql([0, 0])
        end
      end
    end

    describe 'color attr' do
      context 'with black color' do
        it 'has the "black" color' do
          expect(basic_piece.color).to eql('black')
        end
      end
    end
  end
end
