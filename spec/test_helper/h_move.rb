require 'rspec/expectations'
require_relative './h_piece'

RSpec::Matchers.define :contain_exact_move do |*expected|
  match do |actual|
    return false if expected.size != actual.size
    return false if expected.sort_by(&from) != actual.sort_by(&from)

    # expected.each.with_index do |m, i|
    #   return false unless pieces_equal?(m[0], actual[i][0])
    # end
    true
  end
end
