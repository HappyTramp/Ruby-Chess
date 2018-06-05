require_relative './pieces/pieces'

# the chess board
class Board
  attr_accessor :grid

  # init the board with a grid on which the piece will be placed
  def initialize(
    king_positions:   [[0, 4], [7, 4]],
    queen_positions:  [[0, 3], [7, 3]],
    rook_positions:   [[0, 0], [0, 7], [7, 0], [7, 7]],
    knight_positions: [[0, 1], [0, 6], [7, 1], [7, 6]],
    bishop_positions: [[0, 2], [0, 5], [7, 2], [7, 5]],
    pawn_positions:   [1, 6].product((0..7).to_a)
  )
    @grid = Array.new(8) { Array.new 8 }

    @grid.map!.with_index do |row, i|
      row.map!.with_index do |_, j|
        color = i < 4 ? 'black' : 'white'

        case [i, j]
        when *king_positions   then Piece::King.new [i, j], color
        when *queen_positions  then Piece::Queen.new [i, j], color
        when *rook_positions   then Piece::Rook.new [i, j], color
        when *knight_positions then Piece::Knight.new [i, j], color
        when *bishop_positions then Piece::Bishop.new [i, j], color
        when *pawn_positions   then Piece::Pawn.new [i, j], color
        else EmptyCell.new [i, j]
        end
      end
    end
  end

  # cell at the position [x, y]
  def [](x, y)
    index_in_border?(x, y) ? @grid[x][y] : false
  end

  # set cell at position [x, y] to value
  def []=(x, y, value)
    @grid[x][y] = value if index_in_border?(x, y)
  end

  # get the row at the x index
  def get_row(x)
    @grid[x]
  end

  # get the column at the y index
  def get_column(y)
    @grid.transpose[y]
  end

  # get the (anti) diagonal that go through the [x, y] index
  def get_diagonal(x, y, anti: false)
    # loop backward in diagonal to find the origin
    x_stop, x_modifier = anti ? [0, -1] : [7, 1]
    until x == x_stop || y == 0
      x += x_modifier
      y -= 1
    end

    # go through the (anti) diagonal from the origin
    x_stop, x_modifier = anti ? [7, 1] : [0, -1]
    diag = [self[x, y]]
    until x == x_stop || y == 7
      x += x_modifier
      y += 1
      diag << self[x, y]
    end

    diag
  end

  ROW_SEPARATION = "   ├#{'───┼' * 7}───┤".freeze
  # string representation of the board
  def to_s
    grid_to_string = [
      "     #{('a'..'h').to_a.join('   ')}  ",
      "   ┌#{'───┬' * 7}───┐"
    ]

    @grid.each.with_index do |row, i|
      row_to_string = " #{i + 1} │"
      row.each { |cell| row_to_string << " #{cell} │" }

      grid_to_string.push(row_to_string, ROW_SEPARATION)
    end

    grid_to_string[-1] = "   └#{'───┴' * 7}───┘"
    grid_to_string.join("\n")
  end

  private

  # @returns true if the index [x, y] is in of the borders
  def index_in_border?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end
end
