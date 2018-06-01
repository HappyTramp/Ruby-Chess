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
        rook_modified_positions: [[3, 3]],
        king_modified_positions: [
          [3, 1], [3, 6], [1, 3], [6, 3],
          [0, 0], [1, 5], [5, 1], [6, 6]
        ]
      )
    end
    before do
      @left_side, @right_side =
        subject.send(:horizontal_cells_from_position, testing_board)
      @up_side, @down_side =
        subject.send(:vertical_cells_from_position, testing_board)
      @diag_up_side, @diag_down_side =
        subject.send(:diagonal_cells_from_position, testing_board)
      @anti_diag_up_side, @anti_diag_down_side =
        subject.send(:anti_diagonal_cells_from_position, testing_board)
    end

    describe '#horizontal_cells_from_position' do
      context 'rook at [3, 3]' do
        it 'return a correct list of cells at the left from the position' do
          expect(
            piece_array_deep_equal(
              [nil, King.new([3, 1], 'black'), nil],
              @left_side
            )
          ).to be true
        end
        it 'return a correct list of cells at the right from the position' do
          expect(
            piece_array_deep_equal(
              [nil, nil, King.new([3, 6], 'black'), nil],
              @right_side
            )
          ).to be true
        end
      end
    end

    describe '#vertical_cells_from_position' do
      context 'rook at [3, 3]' do
        it 'return a correct list of cells above the piece position' do
          expect(
            piece_array_deep_equal(
              [nil, King.new([1, 3], 'black'), nil],
              @up_side
            )
          ).to be true
        end
        it 'return a correct list of cells bellow the piece position' do
          expect(
            piece_array_deep_equal(
              [nil, nil, King.new([6, 3], 'white'), nil],
              @down_side
            )
          ).to be true
        end
      end
    end

    # describe '#diagonal_cells_from_position' do
    #   context 'rook at [3, 3]' do
    #     it 'return a correct list of the cells above the piece position in diagonal' do
    #       puts @diag_up_side.inspect
    #       expect(
    #         piece_array_deep_equal(
    #           [nil, nil, King.new([0, 0], 'black')],
    #           @diag_up_side)
    #       ).to be true
    #     end
    #     it 'return a correct list of the cells bellow the piece position in diagonal' do
    #       expect(
    #         piece_array_deep_equal(
    #           [nil, nil, King.new([6, 6], 'white'), nil],
    #           @diag_down_side)
    #       ).to be true
    #     end
    #   end
    # end

    # describe '#anti_diagonal_cells_from_position' do
    #   context 'rook at [3, 3]' do
    #     it 'return a correct list of the cells above the piece position in anti diagonal' do
    #       expect(
    #         piece_array_deep_equal(
    #           [nil, King.new([5, 1], 'white'), nil],
    #           @anti_diag_up_side)
    #       ).to be true
    #     end
    #     it 'return a correct list of the cells bellow the piece position in anti diagonal' do
    #       expect(
    #         piece_array_deep_equal(
    #           [nil, King.new([1, 5], 'black'), nil],
    #           @anti_diag_down_side)
    #       ).to be true
    #     end
    #   end
    # end

    describe '#filter_side' do
      context 'left side' do
        it 'return the cells with a possible movement' do
          expect(
            piece_array_deep_equal(
              [nil],
              subject.send(:filter_side, @left_side)
            )
          ).to be true
        end
      end

      context 'right side' do
        it 'return the cells with a possible movement' do
          expect(
            piece_array_deep_equal(
              [nil, nil],
              subject.send(:filter_side, @right_side)
            )
          ).to be true
        end
      end

      context 'up side' do
        it 'return the cells with a possible movement' do
          expect(
            piece_array_deep_equal(
              [nil],
              subject.send(:filter_side, @up_side)
            )
          ).to be true
        end
      end

      context 'bellow side' do
        it 'return the cells with a possible movement' do
          expect(
            piece_array_deep_equal(
              [nil, nil, King.new([6, 3], 'white')],
              subject.send(:filter_side, @down_side)
            )
          ).to be true
        end
      end
    end
  end
end
