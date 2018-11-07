require_relative '../helper'
require_relative './components/pieces/index'
require_relative './components/pieces/childs/king'
require_relative './components/pieces/childs/rook'
require_relative './components/pieces/childs/pawn'

# verify if special moves are applicable
module SpecialMoves
  # detect if a pawn have reached the end of the board
  def detect_promotion
    (@board.row(0) + @board.row(7))
      .each { |s| return s.position if s.is_a? Pawn }
    false
  end

  # detect if a color can castle (short/long) with the following rules:
  # 1. king isnt in check
  # 2. king nor rook have moved
  # 3. no piece between king and rook
  # 4. squares of the king move arent controlled by the enemy
  def detect_castle(color)
    back_rank = color == :w ? 7 : 0
    no_castle = { short: false, long: false }
    possible_castle = { short: true, long: true }

    # 1.
    return no_castle if in_check?(color)

    # 2.
    short_rook_pos = [back_rank, 7]
    long_rook_pos = [back_rank, 0]
    @history.moves.each do |m|
      next if m.piece.color != color
      return no_castle if m.piece.is_a? King

      possible_castle[:long] = false if m.piece.is_a?(Rook) && m.from == long_rook_pos
      possible_castle[:short] = false if m.piece.is_a?(Rook) && m.from == short_rook_pos
    end

    # 3.
    short_piece_pos = [[back_rank, 5], [back_rank, 6]]
    long_piece_pos = [[back_rank, 1], [back_rank, 2], [back_rank, 3]]
    short_piece_pos.each do |p|
      possible_castle[:short] = false unless @board[*p].empty?
    end
    long_piece_pos.each do |p|
      possible_castle[:long] = false unless @board[*p].empty?
    end

    # 4.
    short_control_pos = short_piece_pos
    long_control_pos = long_piece_pos - [back_rank, 1]
    all_controlled_square(Helper::opposite_color(color)).each do |p|
      possible_castle[:short] = false if short_control_pos.include?(p)
      possible_castle[:long] = false if long_control_pos.include?(p)
    end

    possible_castle
  end

  # detect if a pawn can en passant an other one
  def detect_en_passant(color)
    last_move = @history.last_entry
    return false unless last_move.piece.is_a? Pawn
    return false unless (last_move.to[0] - last_move.from[0]).abs == 2

    neighbour_pos = []
    pos_left = [last_move.to[0], last_move.to[1] - 1]
    pos_right = [last_move.to[0], last_move.to[1] + 1]
    neighbour_pos << pos_left if Helper::in_border?(*pos_left)
    neighbour_pos << pos_right if Helper::in_border?(*pos_right)

    neighbour_pos.map do |p|
      next unless @board[*p].is_a? Pawn

      { from: p, capture: last_move.to,
        to: [p[0] + (color == :w ? -1 : 1), last_move.to[1]] }
    end.compact
  end

  def exec_promotion(position, replacement)
    @board[*position] = Pieces::init(replacement, position)
  end

  def exec_castle(color, side)
    back_rank = color == :w ? 7 : 0
    king_pos = [back_rank, side == :short ? 6 : 2]
    rook_pos = [back_rank, side == :short ? 5 : 3]
    init_king_pos = [back_rank, 4]
    init_rook_pos = [back_rank, side == :short ? 7 : 0]

    @board.move(init_king_pos, king_pos)
    @board.move(init_rook_pos, rook_pos)
  end

  def exec_en_passant(detail)
    @board.move(detail[:from], detail[:to])
    @board[*detail[:capture]] = EmptySquare.new(detail[:capture])
  end
end
