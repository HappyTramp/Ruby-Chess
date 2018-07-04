require 'colorize'

# highlight an array of cells or positions on the board
def board_to_s_positions_highlight(board, *positions, cells: false)
  positions.map!(&:position) if cells

  lines = board.to_s.split("\n")
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
