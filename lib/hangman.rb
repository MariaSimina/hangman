require 'yaml'

class Game
  @@wrong_guesses = []
  @@lives_count = 10
  @@dashes = []
  @@secret_word = ""

  def new_game
    puts "\nThis is a new game of HANGMAN!"
    self.get_secret_word
    self.dashes
    self.play
  end

  def load_game
    print "Choose which HANGMAN game to load: "
    game_name = gets.chomp
    if File.exist? ("saved_files/#{game_name}.yaml")
      game = YAML.load(File.read("saved_files/saved_game.yaml"))
      @@wrong_guesses = game[:wrong_guesses]
      @@lives_count = game[:lives_count]
      @@dashes = game[:dashes]
      @@secret_word = game[:secret_word]
      self.play
    else
      puts "\nThis name does not exist. Please choose from one of the following:"
      names = Dir["saved_files/*"]
      puts names.map {|name| name[(name.index("/") + 1)..(name.index(".")) - 1]}
      load_game
    end
  end

  def play
    puts "Try to guess the secret word"
    puts "\n#{@@dashes.join(" ")}"
    end_message = ""

    until (@@lives_count == 0) || !(@@dashes.include? "_")
      puts "You have #{@@lives_count} lives"

      unless @@wrong_guesses.empty?
        puts "Wrong guesses: #{@@wrong_guesses.join(", ")}"
      end

      get_guess = guess
      
      if get_guess == "save"
        save_game
        puts "Game saved"
        end_message = "game_saved"
        break
      end

      check_guess(get_guess)
      puts "\n#{@@dashes.join(" ")}"
    end

    puts "Secret word was: #{@@secret_word} \nGame over!" unless end_message == "game_saved"
  end

  def save_game
    to_yaml = YAML.dump ({
      :wrong_guesses => @@wrong_guesses,
      :lives_count => @@lives_count,
      :dashes => @@dashes,
      :secret_word => @@secret_word
    })

    Dir.mkdir('saved_files') unless Dir.exist? ('saved_files')
    
    print "Write what name you want the saved file to have: "
    filename = gets.chomp

    if File.exist? ("saved_files/#{filename}.yaml")
      print "This name already exists. Do you want to rewrite the game? Write YES or NO: "
      player_answer = gets.chomp

      until (player_answer == "YES") || (player_answer == "NO")
        print "Only YES or NO options available: "
        player_answer = gets.chomp
        puts player_answer
      end

      if player_answer == "YES"
        File.open("saved_files/#{filename}.yaml", "w") do |file|
          file.puts to_yaml
        end
      elsif player_answer == "NO"
        save_game
      end
    end

    File.open("saved_files/#{filename}.yaml", "w") do |file|
      file.puts to_yaml
    end
  end

  def guess
    get_guess = ""
    until ((get_guess.length == 1) && (get_guess =~ /[[:alpha:]]/)) || (get_guess == "save")
      print "Please write one letter, or type save to save the game: "
      get_guess = gets.chomp.downcase
    end

    while (@@wrong_guesses.include? get_guess) || (@@dashes.include? get_guess)
      print "You already chose that letter. Choose another one:"
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
    puts "Hello and welcome to HANGMAN!"
    puts "Do you want to  play a new game or load last saved game?"
    print "Write 1 for New Game or 2 to Load Game: "
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
