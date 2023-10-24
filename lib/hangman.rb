puts "Hello and welcome to a new game of HANGMAN!"

def get_secret_word
  dictionary = File.read("choices.txt")
  dictionary_array = dictionary.split("\n")
  secret_word = ""

  until (secret_word.length > 5) && (secret_word.length < 12)
    secret_word = dictionary_array.sample
  end

  secret_word
end

def check_guess(word_array, dashes_array, guess, wrong_guesses_array, count)
  if word_array.include? guess
    word_array.each_with_index do |letter, index|
      if letter == guess
        dashes_array[index] = guess
      end
    end
  else
    puts "Wrong guess"
    wrong_guesses_array.push(guess)
    count[0] -= 1
  end
end

def clean_guess(letter, dashes_array, wrong_guesses_array)
  while (wrong_guesses_array.include? letter) || (dashes_array.include? letter)
    puts "You already chose that letter. Choose another one:"
    letter = gets.chomp
  end
  letter
end

secret_word = get_secret_word

dashes = []
secret_word.length.times{dashes.push "_ "}

wrong_guesses = []

count = [10]

secret_word = secret_word.split("")
puts dashes.join(" ")

until (!dashes.include? "_ ") || (count[0] == 0)
  puts "Choose a letter:"
  guess = gets.chomp.downcase
  the_guess = clean_guess(guess, dashes, wrong_guesses)
  check_guess(secret_word, dashes, the_guess, wrong_guesses, count)
  puts "\nYou have #{count[0]} lives."
  puts "Wrong guesses: #{wrong_guesses.join(", ")}"
  puts dashes.join(" ")
end

puts "\nThe word was: #{secret_word.join("")}"
puts "Game over"