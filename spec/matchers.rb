require 'rspec/expectations'
require 'game/user/analyse'
require 'game/components/pieces/pieces'
require_relative '../src/helper'

RSpec::Matchers.define :eq_index_array do |indexes_str|
  match do |indexes|
    exp_indexes = Analyse.index_array(indexes_str)
    return false if exp_indexes.size != indexes.size
    indexes.sort!
    exp_indexes.sort.each_with_index { |m, i| return false if m != indexes[i] }
    true
  end
  failure_message do |indexes|
    "expected: [#{indexes_str}]\n"\
    "     got: [#{indexes.map { |i| Helper::index_to_notation(i) }.join(' ')}]"
  end
  description do
    "be equal to [#{expected}]"
  end
end

RSpec::Matchers.define :eq_move_array do |moves_str|
  match do |moves|
    exp_moves = Move.fmt_array(moves_str)
    return false if exp_moves.size != moves.size
    exp_moves.sort!
    moves.sort.each_with_index { |m, i| return false if m != exp_moves[i] }
    true
  end
  failure_message do |moves|
    exp_moves = Move.fmt_array(moves_str).sort
    "expected: [#{exp_moves.map(&:to_s).join(' ')}]\n"\
    "     got: [#{moves.sort.map(&:to_s).join(' ')}]\n"\
    "    diff: [#{moves.sort.select.with_index { |m, i| m != exp_moves[i] }.map(&:to_s).join(' ')}]"
  end
  description do
    "be equal to [#{moves_str}]"
  end
end

RSpec::Matchers.define :eq_index do |index_str|
  match do |index|
    index == Analyse.notation_index(index_str)
  end
  failure_message do |index|
    "expected: #{index_str} - #{Analyse.notation_index(index_str)}\n"\
    "     got: #{Helper.index_to_notation(index)} - #{index}"
  end
  description do
    "be equal to #{Helper.index_to_notation(index_str)} - #{index_str}"
  end
end

RSpec::Matchers.define :eq_move do |move_str|
  match do |move|
    move == Move.fmt(move_str)
  end
  failure_message do |move|
    "expected: #{move_str}\n"\
    "     got: #{move}"
  end
  description do
    "be equal to #{move_str}"
  end
end

RSpec::Matchers.define :eq_piece do |piece_str|
  match do |piece|
    piece == Pieces.fmt(piece_str)
  end
  failure_message do |piece|
    "expected: #{piece_str} - #{Analyse.notation_index(piece_str[1..-1])}\n"\
    "     got: #{piece.type}#{Helper::index_to_notation(piece.position)} - #{piece.position}"
  end
  description do
    "be equal to #{piece_str}"
  end
end
