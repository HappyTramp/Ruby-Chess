require_relative '../../src/game/components/pieces/pieces'
require_relative '../../src/game/history/move'

# replace 'sc_piece(:Q00)' by 'sc_piece(:Q00)'
def sc_piece(p)
  p = p.to_s
  Pieces::init(p[0].to_sym, [p[1].to_i, p[2].to_i])
end

# replace 'Move.new([0, 0], [1, 1], Pieces::init(:Q, [0, 0])'
# by 'sc_move(:Q00to11)'
def sc_move(m)
  m = m.to_s
  Move.new([m[1].to_i, m[2].to_i], [m[5].to_i, m[6].to_i], sc_piece(m[0..2].to_sym))
end
