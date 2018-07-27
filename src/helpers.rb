# convert notation to an index
def nt(n)
  raise 'notation must be a sym' unless n.is_a? Symbol
  raise 'incorrect notation syntax' if (/[a-h][1-8]/ =~ n.to_s).nil?
  n = n.to_s
  [n[1].to_i - 1, n[0].ord - 97]
end
