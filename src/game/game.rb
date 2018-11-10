require_relative './components/board'
require_relative './special_moves'
require_relative './history/history'
require_relative './history/move'
require_relative './check'
require_relative './user/analyse'

# class that supervise a game execution
class Game
  include SpecialMoves
  include Check

  def initialize(fen_code = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w')
    fen_code, turn_color = fen_code.split(' ')

    @board = Board.new fen_code
    @history = History.new
    @turn_color = turn_color.to_sym
  end

  def start
    loop do
      puts @board
      one_turn
      @turn_color = Helper::opposite_color(@turn_color)
      break if checkmate?
    end
    puts @board
    puts 'Fin du Fun'
  end

  def one_turn
    loop do
      puts "#{@turn_color == :w ? 'white' : 'black'} to move"
      print 'Enter a move: '
      asked_move = gets.chomp

      input_move = Analyse::simple_syntax(asked_move)
      next unless input_move

      move_to_exec = Analyse::move_validity(input_move, legal_move)
      next unless move_to_exec

      if move_to_exec.type_ == :castle
        exec_castle(move_to_exec)
      elsif move_to_exec.type_ == :en_passant
        exec_en_passant(move_to_exec)
      else
        @board.move(move_to_exec.from, move_to_exec.to)
      end

      break
    end
  end

  # all pieces controlled square of a color
  def all_controlled_square(color)
    @board.map_every_square do |s|
      next [] unless s.color == color

      s.controlled_square(@board)
    end.flatten(1).uniq
  end

  # all pieces possible moves position of a color
  def all_possible_move(color, only_position: false)
    @board.map_every_square do |s|
      next [] unless s.color == color
      next s.possible_move(@board) if only_position

      s.possible_move(@board).map do |pm|
        Move.new(s.position, pm, s)
      end
    end.flatten(1).uniq
  end
end
