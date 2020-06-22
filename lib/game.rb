require_relative 'hangman'
puts 'Would you like to?'
puts '1. Load a game'
puts '2. Play new game'
mode = gets.chomp
until /^[12]$/ =~ mode
  puts 'Invalid!'.red
  puts 'Would you like to?'
  puts '1. Load a game'
  puts '2. Play new game'
  mode = gets.chomp
end
hangman = Hangman.new
if mode == '2'
  hangman.game
else
  puts 'Choose a game'
  puts '1. barbs'
  puts '2. canyoubeatme'
  puts '3. hangman'
  puts '4. yourgame'
  game_choice = gets.chomp
  until /^[1234]$/ =~ game_choice
    puts 'Invalid!'.red
    puts 'Choose a game'
    puts '1. barbs'
    puts '2. canyoubeatme'
    puts '3. hangman'
    puts '4. Your saved game'
    game_choice = gets.chomp
  end
  hangman.load_game(game_choice)
end