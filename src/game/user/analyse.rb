require_relative '../../helper'

module Analyse
  # alternative format from:to -> 'a1:a4' to PGN
  def self.simple_syntax(string_move)
    return { type_: :castle, side: :short } if string_move == 'O-O'
    return { type_: :castle, side: :long } if string_move == 'O-O-O'

    return false unless string_move.match?(/^[a-h][1-8]:[a-h][1-8]$/)

    { type_: :normal,
      from: notation_to_index(string_move[0..1]),
      to: notation_to_index(string_move[3..4]) }
  end

  def self.move_validity(input_move, possible_moves)
    possible_moves.each do |m|
      if input_move[:type_] == :castle && m.type_ == :castle
        return m if m.side == input_move[:side]
      elsif m.from == input_move[:from] && m.to == input_move[:to]
        return m
      end
    end
    false
  end

  def self.notation_to_index(n)
    [(0..7).to_a.reverse[n[1].to_i - 1], n[0].ord - 97]
  end
end
