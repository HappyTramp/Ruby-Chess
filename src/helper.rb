# module of the helpers of the application
module Helper
  # true if the index [x, y] is in of the borders
  def self.in_border?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  # return the opposite color
  def self.opposite_color(color)
    color == :w ? :b : :w
  end

  def self.index_to_notation(index)
    y, x = index
    "#{(x + 97).chr}#{(1..8).to_a.reverse[y]}"
  end
end
