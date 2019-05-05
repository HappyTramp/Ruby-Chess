require_relative '../user/analyse'
require_relative '../components/pieces/pieces'
require_relative '../../helper'

# class of a move
class Move
  attr_reader :from, :to, :piece, :side, :en_pass_capture
  attr_accessor :replacement

  def initialize(from: nil, to: nil, piece: nil, side: nil,
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

  def make(board, revert = false)
    case type
    when :normal
      if revert
        board.move(@to, @from)
        board[*@to] = @capture
      else
        @capture = board.move(@from, @to)
      end
    when :castle
      back_rank = piece.color == :w ? 7 : 0
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
          piece.color == :w ? @replacement : @replacement.to_s.downcase.to_sym,
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

  def <=>(other)
    return @from <=> other.from if (@from <=> other.from) != 0
    return @to <=> other.to if (@to <=> other.to) != 0
    puts 'to'
    return @piece.type.to_s <=> other.piece.type.to_s if (@piece.type.to_s <=> other.piece.type.to_s) != 0

    case type
    when :castle
      return @side.to_s <=> other.side.to_s if (@side.to_s <=> other.side.to_s) != 0
      return 0
    when :promotion
      return @replacement.to_s <=> other.replacement.to_s if (@replacement.to_s <=> other.replacement.to_s) != 0
      return 0
    when :en_passant
      return @en_pass_capture <=> other.en_pass_capture if (@en_pass_capture <=> other.en_pass_capture) != 0
      return 0
    end
    0
  end

  def to_s
    if %i[normal promotion en_passant].include?(type)
      f = Helper.index_to_notation(@from)
      t = Helper.index_to_notation(@to)
      ep_cap = Helper.index_to_notation(@en_pass_capture) if type == :en_passant
    end
    piece_repr = @piece.color == :w ? @piece.type : @piece.type.downcase
    {
      normal:     "#{piece_repr}#{f}>#{t}",
      castle:     "#{piece_repr}#{@side == :long ? 'O-O-O' : 'O-O'}",
      promotion:  "#{piece_repr}#{f}>#{t}=#{@replacement}",
      en_passant: "#{piece_repr}#{f}>#{t}:#{ep_cap}"
    }[type]
  end

  def self.fmt(fmt_string)
    color = fmt_string[0] == fmt_string[0].upcase ? :w : :b
    piece_type = fmt_string[0].to_sym
    back_rank = color == :w ? 7 : 0
    infos = fmt_string[1..-1]
    if infos == 'O-O'
      return Move.new(from: [back_rank, 4], to: [back_rank, 6],
                      piece: Pieces::init(piece_type, [back_rank, 4]), side: :short)
    elsif infos == 'O-O-O'
      return Move.new(from: [back_rank, 4], to: [back_rank, 2],
                      piece: Pieces::init(piece_type, [back_rank, 4]), side: :long)
    end
    from = Analyse::notation_index(infos[0..1])
    to = Analyse::notation_index(infos[3..4])
    piece = Pieces::init(piece_type, from)
    if infos.include?('=')
      return Move.new(from: from, to: to, piece: piece, replacement: infos[-1] == 'u' ? :unknown : infos[-1].to_sym)
    elsif infos.include?(':')
      return Move.new(from: from, to: to, piece: piece, en_pass_capture: Analyse::notation_index(infos[-2..-1]))
    end
    Move.new(from: from, to: to, piece: piece)
  end

  def self.fmt_array(fmt_string)
    fmt_string.split.map { |m| fmt(m) }
  end
end

class SANParsedMove
  attr_reader :piece_type, :from_specifier, :is_capture, :to, :replacement, :check

  def initialize(piece_type, from_specifier, is_capture, to, replacement, check)
    @piece_type     = piece_type
    @from_specifier = from_specifier
    @is_capture     = is_capture
    @to             = to
    @check          = check
    @replacement    = replacement
  end

  def ==(other)
    return false unless other.is_a? SANParsedMove

    instance_variables.zip(other.instance_variables).each do |n, o_n|
      return false if n != o_n
      return false if instance_variable_get(n) != other.instance_variable_get(o_n)
    end

    true
  end

  def to_s
    "#{@piece_type} #{@from_specifier} #{'x' if @is_capture} #{to} #{replacement} #{check}"
  end
end
