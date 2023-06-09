#  frozen_string_literal: false

# Player class lays out the possible actions for the code maker
class CodeMaker
  # def choose_code(code_maker_type)
  #   code_maker_type.choose_code
  def choose_code
  end

  # def code(code_maker_type)
  #   code_maker_type.code
  #   puts code_maker_type.code
  def code
  end

  # def evaluate_guess(code_maker_type, guess)
  #   code_maker_type.evaluate_guess(guess)
  def evaluate_guess(guess)
    guess
  end
end

class CodeCracker 
  #def make_guess(code_cracker_type, feedback, previous_guess)
  #  code_cracker_type.make_guess(feedback, previous_guess)
  def make_guess(feedback, previous_guess)
  end
end

# clas outlining how computer plays the code maker role
class ComputerCodeMaker < CodeMaker
  attr_accessor:code

  def initialize
    @code = ''
  end

  def choose_code
    4.times do
      ascii = rand(65..70)
      letter = ascii.chr
      @code += letter
    end
  end

  # FIX THIS
  def evaluate_guess(_fb, guess)
    feedback = Array.new(4, '')

    # Check for direct matches
    4.times do |i|
      feedback[i] = 'X' if guess[i] == code[i]
    end

    # loop over code indexes
    4.times do |i|
      # loop over guess indexes
      4.times do |j|
        # if this letter has already been matched to a guess, continue
        break if feedback[i] == 'X'
        next if feedback[j] == 'X' || feedback[j] == 'O'

        next unless @code[i] == guess[j]

        feedback[j] = 'O'
        break
      end
    end
    feedback.shuffle
    feedback_to_string(feedback)
  end

  def feedback_to_string(feedback)
    string = ''
    feedback.each do |elm|
      string += elm if elm == 'X' || elm == 'O'
    end
    string
  end
end

# class outlining how player plays the code maker role
class PlayerCodeMaker < CodeMaker
  attr_reader :code

  def initialize
    @code = ''
  end

  def choose_code
    4.times do
      loop do
        break if choose_letter?
      end
    end
  end

  def letter_valid?(letter)
    return false if letter.length != 1

    ascii = letter.ord
    ascii >= 97 && ascii <= 102 || ascii >= 65 && ascii <= 70
  end

  def choose_letter?
    puts 'Choose a letter between A and F'
    letter = gets.chomp
    if letter_valid?(letter)
      letter.upcase!
      @code += letter
      return true
    end
    false
  end

  def evaluate_guess(feedback, guess)
    loop do
      puts "You choose the code #{@code}. Your opponent guessed #{guess}."
      puts "Please evaluate the accuracy of your opponent's guess using X's and O's."
      feedback = gets.chomp.upcase
      break if valid_feedback?(feedback)
    end
       
    feedback

  end

  def valid_feedback?(string)

    valid_chars = true
    string.each_char do |c|
      valid_chars = false unless c == 'X'|| c == 'O'
    end
    string.length <= 4 && valid_chars
  end

end

class ComputerCodeCracker < CodeCracker

  @all_codes
  @codes

  def initialize
    @all_codes = initialize_all_codes
    @codes = @all_codes
  end

  def initialize_all_codes
    codes = []
    %w[A B C D E F].each do |i|
      %w[A B C D E F].each do |j|
        %w[A B C D E F].each do |k|
          %w[A B C D E F].each do |l|
            codes << "#{i}#{j}#{k}#{l}"
          end
        end
      end
    end
    codes
  end

  def get_feedback_count(string)
    feedback_breakdown = { O: 0, X: 0 }
    string.each_char do |char|
      if char == 'O'
        feedback_breakdown[:O] += 1
      elsif char == 'X'
        feedback_breakdown[:X] += 1
      end
    end
    feedback_breakdown
  end

  def remove_impossible_guesses(feedback, guess)
    feedback_nums = get_feedback_count(feedback)
    ccm = ComputerCodeMaker.new
    @codes.select do |code|
      ccm.code = code
      result = ccm.evaluate_guess(guess)
      result_nums = get_feedback_count(result)
      result_nums[:O] == feedback_nums[:O] && result_nums[:X] == feedback_nums[:X]
    end
  end

  def find_optimal_guess
    # see how many of all possible remaining codes are ruled out by guessing a particular code and all possible feedback
    possible_feedback = ['', 'X', 'O', 'XX', 'OO', 'XXX', 'OOO', 'XXXX', 'OOOO', 'XO', 'XXO', 'XOO', 'XXXO', 'XXOO', 'XOOO']
    code_scores = []
    @codes.each do |code|
      feedback_scores = []
      possible_feedback.each do |feedback|
        feedback_scores << remove_impossible_guesses(code, feedback).size
      end
      code_scores << feedback_scores.max
    end
    min_score = code_scores.min
    min_index = 0
    code_scores.each_with_index do |score, index|
      min_index == index if score == min_score
    end
    @codes[min_index]
  end

  def make_guess(feedback, previous_guess)
    return 'AAAA' if previous_guess == ''

    @codes = remove_impossible_guesses(feedback, previous_guess)
    find_optimal_guess
  end
end

# Lays out the functionality of a player with the code cracker role
class PlayerCodeCracker < CodeCracker
  def make_guess(feedback, previous_guess)
    guess = ''
    loop do
      puts 'Guess a 4-letter code using the letters A-F.'
      guess = gets.chomp
      guess.upcase!
      break if valid_guess?(guess)
    end
    guess
  end

  def valid_guess?(guess)
    valid_chars = true
    guess.each_char do |c|
      ascii = c.ord
      if ascii < 65 || ascii > 70
        valid_chars = false
        break
      end
    end
    valid_chars && guess.length == 4
  end
end

def input_valid?(input)
  input == 1 || input == 2
end

def make_code_maker(type)
  case type
  when 1
    PlayerCodeMaker.new
  when 2
    ComputerCodeMaker.new
  end
end

def make_code_cracker(type)
  case type
  when 1
    ComputerCodeCracker.new
  when 2
    PlayerCodeCracker.new
  end
end

puts 'Welcome player. Would you like to play as the code maker (1) or the code cracker (2)?'
x = ''
loop do
  puts 'Enter a 1 or a 2'
  x = gets.chomp.to_i
  break if input_valid?(x)
end

cm = make_code_maker(x)
cc = make_code_cracker(x)

cm.choose_code
guess = ''
feedback = ''
has_won = false
12.times do
  if feedback == 'XXXX'
    has_won = true
    break
  end
  guess = cc.make_guess(feedback, guess)
  feedback = cm.evaluate_guess(feedback, guess)
  puts "The guess was scored feedback of #{feedback}"
end

if has_won
  puts "Congradulations you have won. The hidden code is #{cm.code}."
else
  puts "You have run out of guesses. Unfortunetly you have lost. The correct code was: #{cm.code}"
end
