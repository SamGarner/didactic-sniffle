# frozen_string_literal: false

# Initialize Game
# create game board
# create two players
# create six colors for guessing (Board)
# generate 4 piece secret code (Player)
# set guess counter = 12 (Board)

# Game - initializes new game and game loop
class Game
  def initialize(codebreaker = 'human', codemaker = 'computer')
    @codebreaker = Player.new('human')#(codebreaker)
    puts "yes"
    @codemaker = Player.new('computer')#(codemaker)
    puts "yes2"
    @board = Board.new
    @board.guess_counter = 12 #remaining guesses
  end

  def game_loop
    @game_over = 0
    while @board.guess_counter > 0
      @board.display_last_guess unless @board.guess_counter == 12   
      @codebreaker.guess_secret_code
      if !@board.valid_guess?(@codebreaker.new_guess_array)
        puts 'invalid guess...please try again'
        next
      else
        @codebreaker.add_guess_to_board
        @codebreaker.reset_correct_count
        @codebreaker.count_exact_matches
        @codebreaker.count_remaining_color_only_matches
        @board.feedback
        @board.update_guess_counter
      end
    end
  end
end

# board - controls game setup and guess validations
class Board
  attr_accessor :guess_counter

  def initialize
    @board_array = Array.new(12) { Array.new(4) }
    @colors = ['green', 'blue', 'yellow', 'white', 'black', 'pink']
    # if codemaker is computer, generate secret code
    #@codemaker.player_type == 'computer' ? generate_secret_code : nil # update this to 
                                              # ask for human input code for v2
  end

  def generate_secret_code
    @board_array[0].map! { |n| n = @colors.sample }
  end

  def valid_guess?(guess_array)
    guess_array.all? { |guess| @colors.include?(guess) } && guess_array.length == 4
  end

  def update_guess_counter
    @guess_counter -= 1
  end

  def feedback
    @codemaker.player_type == 'computer' ? computer_feedback : human_feedback
  end

  def display_last_guess # runs after @guess_counter is updated
    @last_guess = 12 - @guess_counter
    puts "#{guess_counter} guesses remaing. Last guess:\n"
    @board_array[@last_guess]
  end
end

# player - controls codebreaker guess input and codemaker reply
class Player
  attr_accessor :player_type, :new_guess_array

  # def initialize(type)
  #   valid_player_type?(type) ? @type = type : "Please retry with valid player types(s): 'human' or 'computer'" # 'human' or 'computer'
  # end

  def initialize(type)
    @player_type = type
    # if valid_player_type?(type)
    #   @type = type
    # else 
    #   "Please retry with valid player types(s): 'human' or 'computer'" # 'human' or 'computer'
    # end
  end

  def valid_player_type?(type)
    ['human','computer'].include?(self.player_type.to_s.downcase)
  end

  def guess_secret_code
    puts 'enter four colors (duplicates OK) separated by spaces to guess the code:'
    @new_guess_array = gets.chomp.downcase.split()#gsub(' ','').split(',')
  end
    # validate

  def reset_correct_count
    @correct_count = 0
    @color_only_count = 0
  end

  def add_guess_to_board
    @guess_row = 13 - @board.guess_counter
    (0..3).each do |n|
      @board_array[@guess_row][n] = @new_guess_array[n]
    end
  end

  def count_exact_matches
    @turn_check = @board_array[0]
    (0..3).each do |n|
      if @new_guess_array[n] == @board_array[0][n]
        @correct_count += 1
        # update board array to match the new guess array before starting to alter it below
        @new_guess_array[n] = ''
        @turn_check[0][n] = ''
      end
    end
  end

  def count_remaining_color_only_matches
    @new_guess_array.each do |n|
      if @turn_check.include?(new_guess_array[n])
        @color_only_count += 1
        @matching_color_only_space = @turn_check.index(new_guess_array[n])
        @turn_check.delete_at(@matching_color_only_space)
        @new_guess_array[n] = ''
      end
    end
  end

  def computer_feedback
    if @correct_count == 4
      puts "GAME OVER -- You cracked the code!"
      @game_over = 1
    elsif @board.guess_counter == 0
      puts "GAME OVER -- You've used all of your chances :("
      @game_over = 1
    else
      puts "#{correct_count} exact matches. In addition, #{color_only_count} correct
      color guesses"
    end
  end

  def human_feedback
    end
  end 

game = Game.new
game.game_loop
# Game loop
# (show previous guess unless guess counter = 12) (Board)
# guess 4 piece code (Player)
  # validate 4 piece code (Board)
# check each of the four pieces (Board)
# provide feedback on each of the four pieces (Player)
  # number of fully correct guesses, number of correct colors, number fully wrong
  # end if correct guess
# subtract one turn from guess counter
# display number of turns remaining (Board)
  # end if 0 turns left


# lezione
# to access values in a subarray use array[a][b]
# e.g. test_array = [[1,2,3],[4,5,6],[7,8,9]]
# to access 5, test_array[1][1]
# to access 8, test_array[2][1] NOT [2,1] or [2[1]]