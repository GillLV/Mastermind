require 'templates'

# class outlining how computer plays the code maker role
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