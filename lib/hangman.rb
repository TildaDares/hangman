require 'colorize'
require 'yaml'
class Hangman
  def initialize
    @incorrect_guesses_remaining = 10
    @incorrect_letters = []
    create_random_word
  end

  def create_random_word
    five_to_twelve_lettered_words = []
    dictionary = File.open('5desk.txt','r')
    dictionary.each_line do |words|
      if words.chomp.length >= 5 && words.chomp.length <= 12
        five_to_twelve_lettered_words << words.chomp
      end
    end
    dictionary.close
    @random_word = five_to_twelve_lettered_words.sample
    @rand_word_array = Array.new(@random_word.length, '-')
  end

  def save_game
    File.open('./saved_games/yourgame.yml', 'w') { |f| YAML.dump([] << self, f)}
    exit
  end

  def load_game(game_choice)
    case game_choice
    when '1'
      yaml = YAML.load_file('./saved_games/barbs.yml')
    when '2'
      yaml = YAML.load_file('./saved_games/canyoubeatme.yml')
    when '3'
      yaml = YAML.load_file('./saved_games/hangman.yml')
    else
      yaml = YAML.load_file('./saved_games/yourgame.yml')
    end
       @random_word = yaml['random_word']
       @rand_word_array = yaml['rand_word_array']
       @incorrect_guesses_remaining = yaml['incorrect_guesses_remaining']
       @incorrect_letters = yaml['incorrect_letters']
      game
  end

  def check_random_word_array(guess, word, array)
    if word.include? (guess)
      word.each_with_index do |letters, idx|
        if letters == guess
          array[idx] = guess
        end
      end
    else
      @incorrect_guesses_remaining -= 1
      if /#{guess}/ =~ @incorrect_letters.to_s
        #do nothing
      else
        @incorrect_letters << ' ' << guess.red
      end
    end
    incorrect_color(@incorrect_guesses_remaining)
    array
  end

  def check_win(word, array)
    if word.split('') == array
      puts 'You guessed the word!'
      return true
    end
    false
  end
 
  def incorrect_color(guesses_remaining)
    if guesses_remaining >= 7
      puts "Incorrect guesses remaining: #{@incorrect_guesses_remaining}".green
    elsif guesses_remaining >= 5 && guesses_remaining < 7
      puts "Incorrect guesses remaining: #{@incorrect_guesses_remaining}".yellow
    else
      puts "Incorrect guesses remaining: #{@incorrect_guesses_remaining}".red
    end
  end

  def game
    until @incorrect_guesses_remaining == 0
      puts "#{@rand_word_array.join('')}  #{@incorrect_letters.join}\n\n" 
      puts "Enter your guess (single letters only and no duplicates) or type 'save' to save your game"
      letter_guess = gets.chomp
      if /save/i =~ letter_guess
        save_game 
      else
        until /^[a-z]$/i =~ letter_guess || @rand_word_array.include?(letter_guess)
          puts 'Invalid!'.red
          puts 'Enter your guess (single letters only and no duplicates)'
          letter_guess = gets.chomp
        end
        @rand_word_array = check_random_word_array(letter_guess, @random_word.split(''), @rand_word_array)
        return if check_win(@random_word, @rand_word_array)
     end
    end
  end
end