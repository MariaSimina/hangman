require 'yaml'

class Game
  @@wrong_guesses = []
  @@lives_count = 10
  @@dashes = []
  @@secret_word = ""

  def new_game
    puts "Hello and welcome to a new game of HANGMAN!"
    self.get_secret_word
    self.dashes
    self.play
  end

  def load_game
    puts "This is your saved HANGMAN game!"
    game = YAML.load(File.read("saved_files/saved_game.yaml"))
    @@wrong_guesses = game[:wrong_guesses]
    @@lives_count = game[:lives_count]
    @@dashes = game[:dashes]
    @@secret_word = game[:secret_word]
    self.play
  end

  def play
    puts "Try to guess the secret word"
    puts "\n#{@@dashes.join(" ")}"
    end_message = ""

    until (@@lives_count == 0) || !(@@dashes.include? "_")
      if save?
        save_game
        puts "Game saved"
        end_message = "game_saved"
        break
      end

      puts "You have #{@@lives_count} lives"

      unless @@wrong_guesses.empty?
        puts "Wrong guesses: #{@@wrong_guesses.join(", ")}"
      end

      get_guess = guess
      check_guess(get_guess)
      puts "\n#{@@dashes.join(" ")}"
    end

    end_game(end_message)
  end

  def end_game(message)
    puts "Secret word was: #{@@secret_word} \n Game over!" unless message == "game_saved"
  end

  def save?
    player_choice = ""

    until (player_choice == "1") || (player_choice == "2")
      puts "Do you want to save this game? Write 1 to save the game or 2 to continue"
      player_choice = gets.chomp
    end

    if player_choice == "1"
      true
    else
      false
    end
  end

  def save_game
    to_yaml = YAML.dump ({
      :wrong_guesses => @@wrong_guesses,
      :lives_count => @@lives_count,
      :dashes => @@dashes,
      :secret_word => @@secret_word
    })

    Dir.mkdir('saved_files') unless Dir.exist? ('saved_files')

    File.open("saved_files/saved_game.yaml", "w") do |file|
      file.puts to_yaml
    end
  end

  def guess
    get_guess = ""
    until (get_guess.length == 1) && (get_guess =~ /[[:alpha:]]/)
      puts "Please write one letter:"
      get_guess = gets.chomp.downcase
    end
    
    while (@@wrong_guesses.include? get_guess) || (@@dashes.include? get_guess)
      puts "You already chose that letter. Choose another one:"
      get_guess = gets.chomp.downcase
    end

    get_guess
  end

  def check_guess(guess)
    secret_word = @@secret_word.split("")
    if secret_word.include? guess
      secret_word.each_with_index do |letter, index|
        if letter == guess
          @@dashes[index] = guess
        end
      end
    else
      puts "Wrong guess"
      @@wrong_guesses.push(guess)
      @@lives_count -= 1
    end
  end

  def get_secret_word
    dictionary = File.read("choices.txt")
    dictionary_array = dictionary.split("\n")
    secret_word = ""

    until (secret_word.length > 5) && (secret_word.length < 12)
      secret_word = dictionary_array.sample
    end

    @@secret_word = secret_word
  end

  def dashes
    @@secret_word.length.times{@@dashes.push "_"}
  end
end

def play_hangman
  player_choice = ""
  until (player_choice == "1") || (player_choice == "2")
    puts "Do you want to  play a new game or load last saved game?
    Write 1 for New Game or 2 to Load Game"
    player_choice = gets.chomp
  end

  if player_choice == "1"
    game = Game.new
    game.new_game
  elsif player_choice == "2"
    game = Game.new
    game.load_game
  end
end

play_hangman
