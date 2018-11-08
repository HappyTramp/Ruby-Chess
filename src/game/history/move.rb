# class of a move
class Move
  attr_reader :from, :to, :piece, :type_, :color, :side, :replacement, :capture

  def initialize(from = nil, to = nil, piece = nil, type_: :normal,
                 color: nil, side: nil, capture: nil)
    if type_ != :normal
      case type_
      when :castle
        @color = color
        @side = side
      when :en_passant then @capture = capture
      end
    end

    @from  = from
    @to    = to
    @piece = piece
    @type_ = type_
  end

  def init_special(type) end

  def ==(other)
    return false unless other.is_a?(Move)

    instance_variables.zip(other.instance_variables).each do |n, o_n|
      return false if n != o_n
      return false if instance_variable_get(n) != other.instance_variable_get(o_n)
    end

    true
  end
end
