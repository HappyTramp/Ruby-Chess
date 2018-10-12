# convert notation to an index
def pos_nt(n)
  raise 'notation must be a sym' unless n.is_a? Symbol
  raise 'incorrect notation syntax' if (/[a-h][1-8]/ =~ n.to_s).nil?
  n = n.to_s
  [(0..7).to_a.reverse[n[1].to_i - 1], n[0].ord - 97]
end

# @returns true if the index [x, y] is in of the borders
def index_in_border?(x, y)
  x.between?(0, 7) && y.between?(0, 7)
end

def reverse_color(color)
  color == :w ? :b : :w
end
