require 'rspec/expectations'
require_relative './h_board'

RSpec::Matchers.define :contain_exact_positions do |*positions|
  match do |tb_and_piece|
    tb, piece = tb_and_piece
    piece.controlled_squares(tb).sort == positions.sort
  end

  # print expected and actual board side by side
  failure_message do |tb_and_piece|
    tb, piece = tb_and_piece
    actual_pos = piece.controlled_squares(tb)
    "expected: #{positions}\ngot:      #{actual_pos}\n\n" + \
      board_to_s_positions_highlight(tb, *positions)
      .split("\n")
      .zip(board_to_s_positions_highlight(tb, *actual_pos).split("\n"))
      .map { |lines| "#{lines[0]}   #{lines[1]}" }
      .join("\n")
  end

  description do
    "exactly contain positions: #{positions}"
  end
end

# deeply compare two array of pieces.
RSpec::Matchers.define :equal_piece_array do |expected|
  match do |actual|
    expected.zip(actual).each do |zipped_pieces|
      return false unless pieces_equal?(*zipped_pieces)
    end
    true
  end

  failure_message do |actual|
    "expected: #{piece_array_pretty(expected)}\n"\
    "got:      #{piece_array_pretty(actual)}"
  end

  description do
    "equal: #{piece_array_pretty(expected)}"
  end

  def piece_array_pretty(piece_array)
    "[ #{piece_array.map { |el| el.empty? ? '*' : el.to_s } * ', '} ]"
  end
end

# matcher for pieces_equal?
RSpec::Matchers.define :equal_piece do |expected|
  match { |actual| pieces_equal?(expected, actual) }
  failure_message { "fail: #{expected} != #{actual}" }
end

# compare two instance of BasicPiece or EmptyCell
def pieces_equal?(piece1, piece2)
  return true if piece1.empty? && piece2.empty?
  return false if piece1.empty? || piece2.empty?

  if piece1.class.superclass == BasicPiece && piece2.class.superclass == BasicPiece
    if piece1.class == piece2.class &&
       piece1.color == piece2.color &&
       piece1.position == piece2.position
      return true
    end
  end

  false
end
