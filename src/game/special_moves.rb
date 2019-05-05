require_relative '../helper'
require_relative './history/move'
require_relative './components/pieces/pieces'
require_relative './components/pieces/childs/king'
require_relative './components/pieces/childs/rook'
require_relative './components/pieces/childs/pawn'

# verify if special moves are applicable
module SpecialMoves
  # detect if a pawn have reached the end of the board
  def replace_promotion(color)
    all_normal_moves(color).map do |m|
      if m.piece.type == :P && (m.to[0] == 0 || m.to[0] == 7)
        Move.new(from: m.from, to: m.to, piece: m.piece, replacement: :unknown)
      else
        m
      end
    end
  end

  # detect if a color can castle (short/long):
  def detect_castle(color)
    back_rank = color == :w ? 7 : 0
    castle = { short: true, long: true }

    # king isnt in check
    return [] if in_check?(color)

    # king nor rook have moved
    return [] if @board[back_rank, 4].empty?

    short_rook_pos = [back_rank, 7]
    long_rook_pos  = [back_rank, 0]
    castle[:long]  = false if @board[*long_rook_pos].empty?
    castle[:short] = false if @board[*short_rook_pos].empty?
    @history.moves.each do |m|
      next if m.piece.color != color
      return [] if m.piece.is_a? King

      castle[:long]  = false if m.piece.is_a?(Rook) && m.from == long_rook_pos
      castle[:short] = false if m.piece.is_a?(Rook) && m.from == short_rook_pos
    end

    # no piece between king and rook
    short_piece_pos = [[back_rank, 5], [back_rank, 6]]
    long_piece_pos = [[back_rank, 1], [back_rank, 2], [back_rank, 3]]
    short_piece_pos.each do |p|
      castle[:short] = false unless @board[*p].empty?
    end
    long_piece_pos.each do |p|
      castle[:long] = false unless @board[*p].empty?
    end

    # squares of the king move arent controlled by the enemy
    short_control_pos = short_piece_pos
    long_control_pos = long_piece_pos - [back_rank, 1]
    all_controlled_square(color == :w ? :b : :w).each do |p|
      castle[:short] = false if short_control_pos.include?(p)
      castle[:long] = false if long_control_pos.include?(p)
    end

    possible = []
    if castle[:short]
      possible << Move.new(from: [back_rank, 4], to: [back_rank, 6],
                           piece: Pieces.init(color == :w ? :K : :k, [back_rank, 4]),
                           side: :short)
    end
    if castle[:long]
      possible << Move.new(from: [back_rank, 4], to: [back_rank, 2],
                           piece: Pieces.init(color == :w ? :K : :k, [back_rank, 4]),
                           side: :long)
    end
    possible
  end

  # detect if a pawn can en passant an other one
  def detect_en_passant(color)
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

      Move.new(from: p,
               to: [p[0] + (color == :w ? -1 : 1), last_move.to[1]],
               piece: @board[*p],
               en_pass_capture: last_move.to)
    end.compact
  end
end
