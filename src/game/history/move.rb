# class of a move
class Move
  attr_reader :piece, :from, :to, :side, :en_pass_capture
  attr_accessor :replacement

  def initialize(from = nil, to = nil, piece = nil, side: nil,
                 en_pass_capture: nil, replacement: nil)
    @from            = from
    @to              = to
    @piece           = piece
    @side            = side
    @en_pass_capture = en_pass_capture
    @replacement     = replacement
  end

  def type
    return :castle     unless side.nil?
    return :en_passant unless en_pass_capture.nil?
    return :promotion  unless replacement.nil?
    :normal
  end

  def make(board, turn_color, revert = false)
    case type
    when :normal
      if revert
        board.move(@to, @from)
        board[*@to] = @capture
      else
        @capture = board.move(@from, @to)
      end
    when :castle
      back_rank = turn_color == :w ? 7 : 0
      king_pos = [back_rank, @side == :short ? 6 : 2]
      rook_pos = [back_rank, @side == :short ? 5 : 3]
      init_king_pos = [back_rank, 4]
      init_rook_pos = [back_rank, @side == :short ? 7 : 0]

      if revert
        board.move(king_pos, init_king_pos)
        board.move(rook_pos, init_rook_pos)
      else
        board.move(init_king_pos, king_pos)
        board.move(init_rook_pos, rook_pos)
      end
    when :en_passant
      if revert
        board.move(@to, @from)
        board[*@en_pass_capture] = @capture
      else
        board.move(@from, @to)
        @capture = board[*@en_pass_capture]
        board[*@en_pass_capture] = EmptySquare.new(@en_pass_capture)
      end
    when :promotion
      if revert
        board.move(@to, @from)
        board[*@from] = @piece
        board[*@to] = @capture
      else
        @capture = board.move(@from, @to)
        board[*@to] = Pieces::init(
          turn_color == :w ? @replacement : @replacement.to_s.downcase.to_sym,
          @to
        )
      end
    end
  end

  def ==(other)
    return false unless other.is_a? Move

    instance_variables.zip(other.instance_variables).each do |n, o_n|
      return false if n != o_n
      return false if instance_variable_get(n) != other.instance_variable_get(o_n)
    end

    true
  end

  # def to_s
  #   "#@piece - #@from:#@to"
  # end
end
