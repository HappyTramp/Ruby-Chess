require_relative './components/board'
require_relative './special_moves'
require_relative './history/history'
require_relative './history/move'
require_relative './check'
require_relative './user/analyse'
require_relative '../helper'

# class that supervise a game execution
class Game
  include SpecialMoves
  include Check
  include Analyse

  attr_accessor :board, :history, :turn_color

  def initialize(fen_code = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w')
    fen_code, turn_color = fen_code.split(' ')

    @board = Board.new fen_code
    @history = History.new
    @turn_color = turn_color.to_sym
  end

  def enemy_color
    @turn_color == :w ? :b : :w
  end

  def start
    loop do
      puts @board
      one_turn
      @turn_color = enemy_color
      break if checkmate?
    end
    puts @board
    puts 'Checkmate'
  end

  def one_turn
    loop do
      puts "#{@turn_color == :w ? 'white' : 'black'} to move"
      print 'Enter a move: '
      asked_move = gets.chomp

      move_to_exec = pgn_syntax(asked_move)
      next unless move_to_exec

      move_to_exec.make(@board, @turn_color)

      break
    end
  end

  # all pieces controlled square of a color
  def all_controlled_square(enemy = false)
    @board.map_every_square do |s|
      next [] unless s.color == (enemy ? enemy_color : @turn_color)

      s.controlled_square(@board)
    end.flatten(1).uniq
  end

  # all pieces possible moves position of a color
  def all_normal_moves(enemy = false, only_position: false)
    @board.map_every_square do |s|
      next [] unless s.color == (enemy ? enemy_color : @turn_color)
      next s.possible_move(@board) if only_position

      s.possible_move(@board).map do |pm|
        Move.new(s.position, pm, s)
      end
    end.flatten(1).uniq
  end

  def all_possible_moves
    parse_normal_moves_promotion + detect_castle + detect_en_passant
  end
end
