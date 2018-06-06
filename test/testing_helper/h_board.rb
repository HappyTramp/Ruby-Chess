require 'colorize'
require 'game_components/board'

# custom Board for testing purpose
class TestingBoard < Board
  def initialize(
    king_modified_positions: [],
    queen_modified_positions: [],
    rook_modified_positions: [],
    knight_modified_positions: [],
    bishop_modified_positions: [],
    pawn_modified_positions: []
  )
    super(
      king_positions: king_modified_positions,
      queen_positions: queen_modified_positions,
      rook_positions: rook_modified_positions,
      knight_positions: knight_modified_positions,
      bishop_positions: bishop_modified_positions,
      pawn_positions: pawn_modified_positions
    )
  end

  # highlight an array of cells or positions on the board
  def to_s_positions_highlight(*positions, cells: false)
    positions.map!(&:position) if cells

    lines = to_s.split("\n")
    "#{lines[0]}\n" + \
      lines[1, 40]
      .map.with_index do |line, i|
        if ['├', '└', '┌', ' '].include?(line[3])
          line
        else
          line[0..3].red + \
            line[4, 40]
            .split('│')
            .map.with_index do |cell, j|
              positions.include?([i / 2, j]) ? cell.to_s.on_blue.bold : cell.to_s.red
            end
            .join('│'.red) + (i.odd? ? '│'.red : '')
        end
      end
      .join("\n")
  end
end

# in the middle of the board
def tb_constructor(piece, *other_pieces_positions)
  tb = TestingBoard.new(king_modified_positions: other_pieces_positions)
  tb[*piece.position] = piece
  tb
end

# piece in corner
def in_corner(corner, piece, *other_pieces_positions)
  tb = TestingBoard.new(king_modified_positions: other_pieces_positions)
  tb[*{
    up_left:    [0, 0],
    up_right:   [0, 7],
    down_left:  [7, 0],
    down_right: [7, 7]
  }[corner]] = piece
  tb
end
