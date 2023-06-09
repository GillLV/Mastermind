#  frozen_string_literal: false

require_relative 'computer_code_maker'
require_relative 'computer_code_cracker'
require_relative 'player_code_maker'
require_relative 'player_code_cracker'


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
