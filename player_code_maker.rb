require_relative 'templates'

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