require 'game_components/pieces/basic_piece'

describe BasicPiece do
  describe '.initialize' do
    context 'with the position [0, 0]' do
      basic_piece = BasicPiece.new([0, 0])

      it 'has the right position param' do
        expect(basic_piece.position).to eql([0, 0])
      end
    end
  end
end
