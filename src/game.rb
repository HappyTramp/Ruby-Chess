require_relative './game_components/board.rb'

# class that supervise a game exectution
class Game
  def initialize(board)
    @board = board
    @moves_historic = []
  end

  def all_pieces_possible_moves
    pieces_possible_moves = []

    # on peut surement utiliser reduce
    (0..7).each do |i|
      @board.get_row(i).each do |cell|
        next if cell.nil?

        pieces_possible_moves << {
          piece: cell,
          position: cell.position,
          possible_moves: cell.get_possible_moves(@board)
        }
      end
    end

    pieces_possible_moves
  end

  def find_pawn_promotion
    @board.get_row(0).each { |cell| return cell.position if cell.class == Pawn }
    @board.get_row(7).each { |cell| return cell.position if cell.class == Pawn }
    nil
  end

  def add_possible_castling(all_possible_moves)
    black_king = all_possible_moves.find { |i| i.position == [0, 4] && i.piece.first_move }
    black_left_rook = all_possible_moves.find { |i| i.position == [0, 0] && i.piece.first_move }
    black_right_rook = all_possible_moves.find { |i| i.position == [0, 7] && i.piece.first_move }

    unless black_king.nil?
      unless  black_left_rook.nil?
        black_king.possible_moves << [0, 2]
      end
      unless black_right_rook.nil?
        black_king.possible_moves << [0, 6]
      end
    end
    

    white_king = all_possible_moves.find { |i| i.position == [7, 4] && i.piece.first_move }
    white_left_rook = all_possible_moves.find { |i| i.position == [7, 0] && i.piece.first_move }
    white_right_rook = all_possible_moves.find { |i| i.position == [7, 7] && i.piece.first_move }

    unless white_king.nil?
      unless white_left_rook.nil?
        white_king.possible_moves << [7, 2]
      end
      unless white_right_rook.nil?
        white_king.possible_moves << [7, 6]
      end
    end


    all_possible_moves
  end

  def detect_check_and_narrow_moves() end

  def detect_en_passant() end
end
