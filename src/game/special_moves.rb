require_relative '../helpers'
require_relative './components/pieces/childs/king'
require_relative './components/pieces/childs/rook'
require_relative './components/pieces/childs/pawn'

# verify if special moves are applicable
module VerifySpecialMoves
  # detect if a pawn have reached the end of the board
  def can_pawn_promotion?
    @board.row(0).each { |s| return s.position if s.is_a? Pawn }
    @board.row(7).each { |s| return s.position if s.is_a? Pawn }
    false
  end

  # detect if a color can castle (short/long) with the following rules:
  # 1. king isnt in check
  # 2. king nor rook have moved 
  # 3. no piece between king and rook
  # 4. squares of the king move arent controlled by the enemy
  def can_castle?(color)
    no_castle = {short: false, long: false}
    possible_castle = {short: true, long: true}
  
    # 1.
    return no_castle if is_in_check?(color)

    # 2.
    short_rook_pos, long_rook_pos =
      color == :w ? [[7, 7], [7, 0]] : [[0, 7], [0, 0]]
    @history.moves.each do |m|
      next if m[:piece].color != color
      return no_castle if m[:piece].is_a? King
      possible_castle[:long] = false if m[:piece].is_a?(Rook) && m[:from] == long_rook_pos
      possible_castle[:short] = false if m[:piece].is_a?(Rook) && m[:from] == short_rook_pos
    end

    # 3.
    short_piece_pos, long_piece_pos =
      color == :w ? [[[7, 5], [7, 6]], [[7, 1], [7, 2], [7, 3]]]
      : [[[0, 5], [0, 6]], [[0, 1], [0, 2], [0, 3]]]
    short_piece_pos.each do |p|
      possible_castle[:short] = false unless @board[*p].empty?
    end
    long_piece_pos.each do |p|
      possible_castle[:long] = false unless @board[*p].empty?
    end

    # 4.
    short_check_pos, long_check_pos =
      short_piece_pos, long_piece_pos - (color == :w ? [7, 1] : [0, 1])
    all_controlled_square(opposite_color(color)).each do |c_pos|
      c_pos[:controlled_square].each do |p|
        possible_castle[:short] = false if short_check_pos.include?(p)
        possible_castle[:long] = false if long_check_pos.include?(p)
      end
    end

    possible_castle
  end

  # detect if a pawn can en passant an other one
  def can_en_passant?(color)
    en_passant_moves = []

    last_move = @history.last_entry
    return false unless last_move[:piece].is_a? Pawn
    return false unless (last_move[:to][0] - last_move[:from][0]).abs == 2

    neighbour_pos = []
    pos_left = [last_move[:to][0], last_move[:to][1] -1]
    pos_right = [last_move[:to][0], last_move[:to][1] + 1]
    neighbour_pos.push(pos_left) if index_in_border?(*pos_left)
    neighbour_pos.push(pos_right) if index_in_border?(*pos_right)


    neighbour_pos.each do |p|
      if @board[*p].is_a? Pawn
        en_passant_moves.push({
          from: p,
          to: [p[0] + (color == :w ? -1 : 1), last_move[:to][1]],
          capture: last_move[:to]})
      end
    end

    en_passant_moves
  end

end

# apply special moves
module ExecuteSpecialMoves

  def exec_pawn_promotion(position)
    
  end

  def exec_castle(color, side)
    
  end

  def exec_en_passant(from, to)
    
  end
end
