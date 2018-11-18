require_relative './pieces/pieces'
require_relative '../../helper'

# the chess board
class Board
  # init the board with a grid on which the piece are placed
  # according to the FEN code
  def initialize(positions = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR')
    @grid = positions.split('/').map.with_index do |row, i|
      row
        .chars.flat_map { |c| c.to_i == 0 ? c : Array.new(c.to_i) { nil } }
        .map.with_index do |p_type, j|
          p_type.nil? ? EmptySquare.new([i, j]) : Pieces::init(p_type, [i, j])
        end
    end

    # temporary test for FEN
    if (@grid[7].is_a?(NilClass) ||
        @grid[7][7].is_a?(NilClass) ||
        @grid[8].class != NilClass ||
        @grid[7][8].class != NilClass)
      raise ArgumentError, 'wrong Board init string'
    end
  end

  # square at the position [x, y]
  def [](x, y)
    Helper::in_border?(x, y) ? @grid[x][y] : false
  end

  # set square at position [x, y] to value
  def []=(x, y, value)
    @grid[x][y] = value if Helper::in_border?(x, y)
  end

  # move a piece from position to an other
  def move(from, to)
    capture = self[*to]
    self[*to] = self[*from]
    self[*to].position = to
    self[*from] = EmptySquare.new(from)
    capture
  end

  # row at the x index
  def row(x)
    @grid[x]
  end

  # column at the y index
  def column(y)
    @grid.transpose[y]
  end

  # (anti)diagonal that go through the [x, y] index
  def diagonal(x, y, anti: false)
    # loop backward in diagonal to find the origin
    x_stop, x_modifier = anti ? [0, -1] : [7, 1]
    until x == x_stop || y == 0
      x += x_modifier
      y -= 1
    end

    # go through the (anti)diagonal from the origin
    x_stop, x_modifier = anti ? [7, 1] : [0, -1]
    diag = [self[x, y]]
    until x == x_stop || y == 7
      x += x_modifier
      y += 1
      diag << self[x, y]
    end

    diag
  end

  def map_every_square
    @grid.flat_map { |r| r.map { |s| yield s } }
  end

  ROW_SEPARATION = "   ├#{'───┼' * 7}───┤".freeze
  INVERSE_INDEXS = (1..8).to_a.reverse.freeze
  # string representation of the board
  def to_s
    grid_to_string = [
      "     #{('a'..'h').to_a.join('   ')}  ",
      "   ┌#{'───┬' * 7}───┐"
    ]

    @grid.each.with_index do |row, i|
      row_to_string = " #{INVERSE_INDEXS[i]} │"
      row.each { |s| row_to_string << " #{s} │" }

      grid_to_string.push(row_to_string, ROW_SEPARATION)
    end

    grid_to_string[-1] = "   └#{'───┴' * 7}───┘"
    grid_to_string.join("\n")
  end
end
