require 'templates'

# Class out lines the funtionality needed for computer to crack the code
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