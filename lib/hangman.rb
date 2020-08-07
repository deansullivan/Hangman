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
        p "Choose a letter: "
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
        else
            p "You've been bamboozled! The secret word was: #{@secret_word}"
        end

    end

end
#Check to see if letter is in word
# Display letter either in display array or guessed array
# Show how many guesses are left

new_game = Hangman.new()
new_game.Start()