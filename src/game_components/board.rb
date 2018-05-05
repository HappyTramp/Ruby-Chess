require_relative './pieces/pieces'

# test
class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new 8 }

    @grid.map!.with_index do |row, i|
      row.map!.with_index do |_, j|
        if [0, 7].include? i
          case
          when [0, 7].include?(j) then Piece::Rook.new([i, j])
          when [1, 6].include?(j) then Piece::Knight.new([i, j])
          when [2, 5].include?(j) then Piece::Bishop.new([i, j])
          when j == 3 then Piece::Queen.new([i, j])
          when j == 4 then Piece::King.new([i, j])
          end
        elsif [1, 6].include? i
          Piece::Pawn.new([i, j])
        end
      end
    end
  end
end
