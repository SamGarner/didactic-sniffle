# frozen_string_literal: false

# Game - initializes new game and game loop
class Game
  def initialize
    @board = Board.new
    @codebreaker = Player.new('human', @board)
    @codemaker = Player.new('computer', @board)
    @board.generate_secret_code # DEFINE for player to switch roles??
    @guess_counter = 12
  end

  def display_number_of_remaining_turns
    if @guess_counter > 0 
      puts "#{@guess_counter} turns left... Try again!\n\n"
    else
      puts "#{@guess_counter} turns left... Game over!\n"
    end
  end

  def play
    while @guess_counter > 0
      @board.display_last_guess unless @guess_counter == 12
      @codebreaker.guess_secret_code
      puts 'Invalid guess format, please try again' unless
        @board.valid_guess?(@codebreaker.new_guess_array)
      next unless
        @board.valid_guess?(@codebreaker.new_guess_array)
      @board.add_guess_to_board(@guess_counter, @codebreaker.new_guess_array)
      @board.reset_match_calculators
      @board.reset_remaining_indices_to_check
      @board.check_exact_matches
      @board.check_color_only_remaining_matches
      @board.display_guess_results
      if @board.exact_match_count == 4
        @guess_counter = 0
        next
      else
        @guess_counter -= 1
      end
      display_number_of_remaining_turns
    end
  end
end

# board - controls game setup and guess validations
class Board
  attr_reader :exact_match_count

  def initialize
    @board_array = Array.new(12) { Array.new(4) }
    @colors = ['green', 'blue', 'yellow', 'white', 'black', 'pink']
  end

  def generate_secret_code #will need to be expanded when want to reverse computer/human roles
    @board_array[0].map! { @colors.sample }
  end

  def valid_guess?(guess_array)
    guess_array.all? { |guess| @colors.include?(guess) } && guess_array.length == 4
  end

  def add_guess_to_board(guess_counter, guess_array)
    @row_for_guess = 13 - guess_counter
    @board_array[@row_for_guess] = guess_array
  end

  def display_last_guess
    puts 'Your last valid guess was:'
    puts @board_array[@row_for_guess].join('-') # puts with an Array will output everything on separate lines, use join
  end

  def reset_match_calculators
    @exact_match_count = 0
    @color_only_match_count = 0
  end

  def reset_remaining_indices_to_check
    @remaining_indices = [0, 1, 2, 3]
  end

  def check_exact_matches
    (0..3).each do |n|
      if @board_array[@row_for_guess][n] == @board_array[0][n]
        @exact_match_count += 1
        @remaining_indices.delete(n)
      end
    end
  end

  # def get_remaining_indices_to_check
  #   @remaining_guess_indices = (0..3).reject { |n| @matched_guess_indices.include?(n) }
  #   @remaining_code_indices = (0..3).reject { |n| @matched_code_indices.include?(n) }
  # end

  def check_color_only_remaining_matches
    @code_copy = @board_array[0].dup
    @guess_copy = @board_array[@row_for_guess].dup
    @remaining_indices.each do |n|
      @remaining_indices.each do |j|
        if @guess_copy[n] == @code_copy[j]
          @color_only_match_count += 1
          @guess_copy[n] = ''
          @code_copy[j] = '-'
        end
      end
    end
  end

  def display_guess_results
    ## use line below for troubleshooting - displays the secret code
    ## puts @board_array[0].inspect
    ##
    if @exact_match_count == 4
      puts "\nCongrats - you cracked the code!\n"
    else
      puts "\n#{@exact_match_count} exact matches and #{@color_only_match_count} other color only matches"
    end
  end
end

# player - controls codebreaker guess input and codemaker reply
class Player
  attr_reader :new_guess_array

  def initialize(player_type, board)
    @board = board
    if valid_player_type?(player_type)
      @player_type = player_type
    else  
      # WILL NEED TO BE UPDATED IF PLAYER ROLES AREN'T BEING HARDCODED AND BECOME AN INPUT OPTION
      # THE ELSE IS NOT CURRENTLY HANDLED CORRECTLY AND GAMEPLAY WILL CONTINUE
      puts "Please retry with valid player types(s): 'human' or 'computer'"
    end
  end

  def valid_player_type?(type)
    %w[human computer].include?(type.to_s.downcase)
  end

  def guess_secret_code
    puts 'choose four colors (green, blue, yellow, white, black, pink - duplicates OK)'\
    ' separated by spaces to guess the code:'
    @new_guess_array = gets.chomp.downcase.split()
  end
end

game = Game.new
game.play

# Game loop
# (show previous guess unless guess counter = 12) (Board)
# guess 4 piece code (Player)
  # validate 4 piece code (Board)
# check each of the four pieces (Board)
# provide feedback on each of the four pieces (Board)
  # number of fully correct guesses, number of correct colors, number fully wrong (Board)
  # end if correct guess (Game)
# subtract one turn from guess counter (Game)
# display number of turns remaining (Game)
  # end if 0 turns left (Game)
