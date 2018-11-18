require_relative '../../helper'

module Analyse
  PGN_MOVE_REGEX = /
    ^(K|Q|R|B|N)?
    ([a-h1-8])?(x)?
    ([a-h][1-8])(\+|\#)?
    (=[QRBN])?$
    /x

  def pgn_syntax(string_move)
    all_poss = all_possible_moves

    return Move.new(side: :short) if string_move == 'O-O' && all_poss.include?(Move.new(side: :short))
    return Move.new(side: :long) if string_move == 'O-O-O' && all_poss.include?(Move.new(side: :long))

    PGN_MOVE_REGEX.match(string_move) do |pgn_match|
      piece_type, position_specifier, capture, to, check, replacement =
        pgn_match.captures

      to = Analyse::notation_to_index(to)
      capture = !capture.nil?
      replacement = replacement.nil? ? nil : replacement[1]
      piece_type = piece_type.nil? ? :P : piece_type.to_sym

      guess = false
      all_poss.each do |m|
        case m.type
        when :normal, :en_passant
          if m.to == to && m.piece.type == piece_type
            if position_specifier.nil?
              guess = m
            elsif m.piece.position[1] == position_specifier.ord - 97
              guess = m
            end
          end
        when :promotion
          if m.to == to
            m.replacement = replacement.to_sym
            guess = m
          end
        end
      end

      return false unless guess

      guess_clone = guess.clone

      if capture && guess.type != :en_passant
        return false if @board[*guess.to].empty?
      elsif check == '+'
        guess_clone.make(@board, @turn_color)
        guess = false unless in_check?(true)
        guess_clone.make(@board, @turn_color, true)
      elsif check == '#'
        guess_clone.make(@board, @turn_color)
        guess = false unless checkmate?(true)
        guess_clone.make(@board, @turn_color, true)
      end
      return guess
    end

    false
  end

  def self.notation_to_index(n)
    [(0..7).to_a.reverse[n[1].to_i - 1], n[0].ord - 97]
  end

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
