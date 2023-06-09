require 'templates'

# Lays out the functionality of a player with the code cracker role
class PlayerCodeCracker < CodeCracker
  def make_guess(_feedback, _previous_guess)
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