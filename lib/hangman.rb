SAVE_FILE_PATH = 'saves/saved'

class Hangman
    def initialize()
        @WORD_LENGTH_MIN = 5
        @WORD_LENGTH_MAX = 12
        @MAX_GUESS = 10
        @guess_left = @MAX_GUESS
        @letters_already_guessed = Array.new
    end

    def generate_secret_word()
        @@dictionary = Array.new # The array that will store the words to be selected as the secret word
        @display_array = Array.new # The array that will be what the player sees when guessing

        @@file_reader = File.readlines "5desk.txt"
        @@file_reader.each { |word| @@dictionary << word.strip if word.length <= @WORD_LENGTH_MAX and word.length >= @WORD_LENGTH_MIN }

        @secret_word = @@dictionary.sample
        @secret_word = @secret_word.downcase
        @secret_word_array = @secret_word.chars

        @secret_word.length.times do
            @display_array << " _ "
        end
        @display = @display_array.join() # Use the @display to get rid of those pesky brackets
    end

    def make_valid_guess()
        @@valid_guess = false
        @@guess = gets.chomp

        while @@valid_guess == false do

            if @letters_already_guessed.include?(@@guess)
                p "You've already guessed that letter."
                @@guess = gets.chomp
            elsif @@guess == "1"
                save_game()
                p "Peace!"
                exit
            elsif @@guess.length == 1 and @@guess.count("a-zA-Z") > 0
                @letters_already_guessed << @@guess
                @@valid_guess = true
            else
                p "You cheeky bugger, thats not a valid guess."
                p "Try again: "
                @@guess = gets.chomp
                @@guess = @@guess.downcase
            end
        end

        return @@guess
    end

    def check_guess(guess)
        if @secret_word_array.include?(@@guess)
            Update_Display(@@guess)
        else
            @guess_left -=1
        end

    end

    def Update_Display(letter)
        @@letter = letter
        @@location_in_array = 0

        @secret_word_array.each do |letter|
            @display_array[@@location_in_array] = @@letter if letter == @@letter
            @@location_in_array += 1
        end

        @display = @display_array.join()
    end

    def Update()
        p @display
        p @display_array
        p "You have #{@guess_left} attempts still remaining."
        p "Letters already guessed: #{@letters_already_guessed}"
        p "Secret word: #{@secret_word}" #Debug purposes
        p "Choose a letter or type '1' to save the game: "
        @guess = make_valid_guess()
        check_guess(@guess)
    end

    def Start()

        p "Are you ready to play a rousing game of Hangman?"
        p "You have #{@MAX_GUESS} tries to guess the secret word."
        
        generate_secret_word()
        while @display != @secret_word and @guess_left != 0 do
            Update()
        end

        if @display == @secret_word
            p "Huzzah! You won."
            p @display
            p @secret_word
        else
            p "You've been bamboozled! The secret word was: #{@secret_word}"
        end
    end

    def save_game()
        serialized_game = Marshal::dump(self)
        Dir.mkdir "saves" unless Dir.exists?("saves")
        saved_game = File.new(SAVE_FILE_PATH, "w")
        saved_game.puts serialized_game
        p "HUZZAH! The game is saved!"
    end

    def continue()
        while @display != @secret_word and @guess_left != 0 do
            Update()
        end

        if @display == @secret_word
            p "Huzzah! You won."
            p @display
            p @secret_word
        else
            p "You've been bamboozled! The secret word was: #{@secret_word}"
        end
    end

end

def start_game()
    game = Hangman.new()
    game.Start()
end

def load_game()
    if File.exists?(SAVE_FILE_PATH)
        saved_game_file = File.open(SAVE_FILE_PATH, "r")
        return Marshal::load(saved_game_file)
    else
        p "There's nothing to load. . ."
        start_game()
    end
end

system('clear')
p "Press '1' to start the game."
p "Press '2' to load a saved game."
p "What  say you?"

choice = nil
until choice == '1' || choice == '2' do
    choice = gets.chomp
end

if choice == '1'
    start_game()
else
    game = load_game()
    game.continue()
end