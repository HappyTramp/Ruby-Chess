require_relative './pieces/pieces'

# test
class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new 8 }

    @grid.map!.with_index do |row, i|
      row.map!.with_index do |_, j|
        color = i < 5 ? 'black' : 'white'
        if [0, 7].include? i
          case
          when [0, 7].include?(j) then Piece::Rook.new [i, j], color
          when [1, 6].include?(j) then Piece::Knight.new [i, j], color
          when [2, 5].include?(j) then Piece::Bishop.new [i, j], color
          when j == 3 then Piece::Queen.new [i, j], color
          when j == 4 then Piece::King.new [i, j], color
          end
        elsif [1, 6].include? i
          Piece::Pawn.new [i, j], color
        end
      end
    end
  end

  def [](x, y)

    @grid[x][y]
  end

  ROW_SEPARATION = "  ├#{'───┼' * 7}───┤"
  def to_s
    grid_to_string = [
      "   #{(1..8).map { |x| ' ' + (96 + x).chr + '  ' }.join}",
      "  ┌#{'───┬' * 7}───┐"
    ]
    
    @grid.each.with_index do |row, i|
      row_to_string = " #{(i + 1).to_s}│"
      
      row.each.with_index do |cell, j|
        row_to_string << " #{cell.nil? ? ' ' : cell} │"
      end

      grid_to_string.push(
        row_to_string,
        i == 7 ? "  └#{'───┴' * 7}───┘" : ROW_SEPARATION
      )
    end

    grid_to_string.join("\n")
  end

  private

  def isIndexInBoundarys?(x, y)
    return false if x < 0 || x > 7 || y < 0 || y > 7
    return true
  end
end
