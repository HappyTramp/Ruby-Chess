require_relative '../../helper'
require_relative '../history/move'

module Analyse
  SAN_MOVE = /^([KQRBN])?([a-h1-8])?(x)?([a-h][1-8])(=[QRBN])?(\+|#)?$/

  # parse a move in the SAN (Standard Algebraic Notation)
  # https://en.wikipedia.org/wiki/Algebraic_notation_(chess)
  def self.parse_san(str_move)
    str_move.strip!
    return Move.new(side: :short) if str_move == 'O-O'
    return Move.new(side: :long)  if str_move == 'O-O-O'

    move_match = SAN_MOVE.match(str_move)
    return false if move_match.nil?
    piece_type, from_specifier, is_capture, to, replacement, check =
      move_match.captures

    to = Analyse::notation_index(to)
    return false unless to
    is_capture = !is_capture.nil?
    piece_type = piece_type.nil? ? :P : piece_type.to_sym
    replacement = replacement.nil? ? nil : replacement[1].to_sym

    unless from_specifier.nil?
      row_from = Analyse::row_notation_index(from_specifier)
      col_from = Analyse::col_notation_index(from_specifier)
      from_specifier = [row_from, nil] if row_from != false
      from_specifier = [nil, col_from] if col_from != false
    end

    check = (check == '+' ? :check : :checkmate) unless check.nil?

    SANParsedMove.new(piece_type, from_specifier, is_capture, to, replacement, check)
  end

  def self.notation_index(n)
    n.strip!
    return false if n.length != 2
    col = col_notation_index(n[0])
    row = row_notation_index(n[1])
    return false unless col && row
    [row, col]
  end

  def self.col_notation_index(col_n)
    col_o = col_n.ord
    return false unless col_o >= 97 && col_o <= 104

    col_o - 97
  end

  def self.row_notation_index(row_n)
    row_o = row_n.ord
    return false unless row_o >= 49 && row_o <= 56

    (0..7).to_a.reverse[row_o - 49]
  end

  def self.index_array(str_indexs)
    str_indexs.split.map { |s| notation_index(s) }
  end

  # UCI
  # alternative format from:to -> 'a1:a4' to PGN
  # def simple_syntax(string_move)
  #   return { type: :castle, side: :short } if string_move == 'O-O'
  #   return { type: :castle, side: :long } if string_move == 'O-O-O'

  #   return false unless string_move.match?(/^[a-h][1-8]:[a-h][1-8]$/)

  #   { type: :normal,
  #     from: Analyse::notation_to_index(string_move[0..1]),
  #     to: Analyse::notation_to_index(string_move[3..4]) }
  # end

  # def simple_move_validity(input_move, possible_moves)
  #   possible_moves.each do |m|
  #     if input_move[:type] == :castle && m.type == :castle
  #       return m if m.side == input_move[:side]
  #     elsif m.from == input_move[:from] && m.to == input_move[:to]
  #       return m
  #     end
  #   end
  #   false
  # end
end
