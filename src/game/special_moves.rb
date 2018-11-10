require_relative '../helper'
require_relative './history/move'
require_relative './components/pieces/pieces'
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
  def detect_castle
    back_rank = @turn_color == :w ? 7 : 0
    castle = { short: true, long: true }

    # 1.
    return [] if in_check?

    # 2.
    short_rook_pos = [back_rank, 7]
    long_rook_pos = [back_rank, 0]
    @history.moves.each do |m|
      next if m.piece.color != @turn_color
      return [] if m.piece.is_a? King

      castle[:long] = false if m.piece.is_a?(Rook) && m.from == long_rook_pos
      castle[:short] = false if m.piece.is_a?(Rook) && m.from == short_rook_pos
    end

    # 3.
    short_piece_pos = [[back_rank, 5], [back_rank, 6]]
    long_piece_pos = [[back_rank, 1], [back_rank, 2], [back_rank, 3]]
    short_piece_pos.each do |p|
      castle[:short] = false unless @board[*p].empty?
    end
    long_piece_pos.each do |p|
      castle[:long] = false unless @board[*p].empty?
    end

    # 4.
    short_control_pos = short_piece_pos
    long_control_pos = long_piece_pos - [back_rank, 1]
    all_controlled_square(Helper::opposite_color(@turn_color)).each do |p|
      castle[:short] = false if short_control_pos.include?(p)
      castle[:long] = false if long_control_pos.include?(p)
    end

    possible = []
    possible << Move.new(type_: :castle, side: :short) if castle[:short]
    possible << Move.new(type_: :castle, side: :long) if castle[:long]
    possible
  end

  # detect if a pawn can en passant an other one
  def detect_en_passant
    last_move = @history.last_entry
    return [] unless last_move.piece.is_a? Pawn
    return [] unless (last_move.to[0] - last_move.from[0]).abs == 2

    neighbour_pos = []
    pos_left = [last_move.to[0], last_move.to[1] - 1]
    pos_right = [last_move.to[0], last_move.to[1] + 1]
    neighbour_pos << pos_left if Helper::in_border?(*pos_left)
    neighbour_pos << pos_right if Helper::in_border?(*pos_right)

    neighbour_pos.map do |p|
      next unless @board[*p].is_a? Pawn

      Move.new(p, [p[0] + (@turn_color == :w ? -1 : 1), last_move.to[1]],
               type_: :en_passant, capture: last_move.to)
    end.compact
  end

  def exec_promotion(pos, replacement)
    @board[*pos] = Pieces::init(replacement, pos)
  end

  def exec_castle(move)
    back_rank = @turn_color == :w ? 7 : 0
    king_pos = [back_rank, move.side == :short ? 6 : 2]
    rook_pos = [back_rank, move.side == :short ? 5 : 3]
    init_king_pos = [back_rank, 4]
    init_rook_pos = [back_rank, move.side == :short ? 7 : 0]

    @board.move(init_king_pos, king_pos)
    @board.move(init_rook_pos, rook_pos)
  end

  def exec_en_passant(move)
    @board.move(move.from, move.to)
    @board[*move.capture] = EmptySquare.new(move.capture)
  end
end
