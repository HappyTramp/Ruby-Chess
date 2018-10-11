require 'rspec/expectations'
require_relative './h_piece'

RSpec::Matchers.define :equal_move_array do |expected|
  match do |actual|
    return false if expected.length != actual.length
    expected.each.with_index do |m, i|
      return false unless pieces_equal?(m[0], actual[i][0])
    end
    true
  end
end

