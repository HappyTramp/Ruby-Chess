require 'game_components/pieces/basic_piece'
require 'game_components/pieces/chess_pieces/king'
require_relative '../testing_helpers.rb'


describe BasicPiece do
  subject { BasicPiece.new [3, 3], 'black' } 

  describe '#initialize' do
    it { expect(subject.position).to eql([3, 3]) }
    it { expect(subject.color).to eql('black') }
  end

  describe 'private methods' do
    let(:testing_board) do
      TestingBoard.new(
        rookModifiedPositions: [[3, 3]],
        kingModifiedPositions: [[3, 1], [3, 6], [1, 3], [6, 3]])
    end
    before do
      @left_side, @right_side =
        subject.send(:horizontalCellsFromPosition, testing_board)
      @up_side, @bellow_side =
        subject.send(:verticalCellsFromPosition, testing_board)
    end

    describe '#horizontalCellsFromPosition' do
      context '3rd element from the 3rd row' do
        it 'return two list of cells (left and right) from the position' do
          expect(
            pieceArrayDeepEqual(
              [nil, King.new([3, 1], 'black'), nil],
              @left_side)
            ).to be true
          
          expect(
            pieceArrayDeepEqual(
              [nil, nil, King.new([3, 6], 'black'), nil],
              @right_side)
            ).to be true
          end
        end
      end
      
      describe '#verticalCellsFromPositions' do
        context '3rd element from the 3rd' do
          it 'return two list of cells (above and bellow) from the position' do
            expect(
              pieceArrayDeepEqual(
                [nil, King.new([1, 3], 'black'), nil],
                @up_side)
              ).to be true
              
            expect(
              pieceArrayDeepEqual(
                [nil, nil, King.new([6, 3], 'white'), nil],
                @bellow_side)
              ).to be true
            end
          end
        end
        
      describe '#filterSide' do
        context 'left side' do
          it 'return the cells with a possible movement' do
            expect(
              pieceArrayDeepEqual(
                [nil],
                subject.send(:filterSide, @left_side))
              ).to be true
          end
        end
      
      context 'right side' do
        it 'return the cells with a possible movement' do
          expect(
            pieceArrayDeepEqual(
              [nil, nil],
              subject.send(:filterSide, @right_side))
            ).to be true
        end
      end
          
      context 'up side' do
        it 'return the cells with a possible movement' do
          expect(
            pieceArrayDeepEqual(
              [nil],
              subject.send(:filterSide, @up_side))
            ).to be true
        end
      end
           
      context 'bellow side' do
        it 'return the cells with a possible movement' do
          expect(
            pieceArrayDeepEqual(
              [nil, nil, King.new([6, 3], 'white')],
              subject.send(:filterSide, @bellow_side))
            ).to be true
        end
      end
    end
  end
end
