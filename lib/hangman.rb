class Game
  @@wrong_guesses = []
  @@lives_count = 10
  @@dashes = []
  @@secret_word = ""

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
          @@dashes[index] = "#{guess} "
        end
      end
    else
      puts "Wrong guess"
      @@wrong_guesses.push(guess)
      @@lives_count -= 1
    end
  end

  def play
    puts "Hello and welcome to a new game of HANGMAN!"
    puts "Try to guess the secret word"
    self.get_secret_word
    self.dashes
    puts "\n#{@@dashes.join("")}"

    until (@@lives_count == 0) || !(@@dashes.include? "_ ")
      puts "You have #{@@lives_count} lives"

      unless @@wrong_guesses.empty?
        puts "Wrong guesses: #{@@wrong_guesses.join(", ")}"
      end

      get_guess = guess
      check_guess(get_guess)
      puts "\n#{@@dashes.join("")}"
    end

    puts "Secret word was: #{@@secret_word}"
    puts "Game over!"
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
    @@secret_word.length.times{@@dashes.push "_ "}
  end
end

game = Game.new
game.play
