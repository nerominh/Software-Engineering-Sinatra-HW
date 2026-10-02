class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses # # Getter and Setter
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  
  def guess(letter)
    # check 4: bad input, check for '', '%', nil to raise argument error on purpose
    if letter.nil? || !letter.match?(/\A[a-z]\z/i) # Regex checking, from start to end of string, if belongs to alphabet and case-insensitive
      raise ArgumentError, "Invalid guess"
    end
    
    # check 3: guessing a letter you've already guessed returns false and changes nothing --> 'A' counts as the same letter as 'a'
    letter = letter.downcase
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)
    
    # check 2: know if guess right or wrong letter
    if @word.include?(letter) # Ask "is this letter in the word"
      @guesses += letter # Add letter to the end of string
    else
      @wrong_guesses += letter
    end
    true
  end
  # check 5: checks for banana, guessing b and n must show b-n-n-
  def word_with_guesses
    @word.chars.map { |ch| @guesses.include?(ch) ? ch : '-' }.join
    # chars split the word in ["b", "a", "n", ...]
    # map goes through each letter
    # ?: if guessed, keep the letter, otherwise use -
    # join: puts the pieces back into one string
  end

  # check 6: check win or lose
  def check_win_or_lose
    return :lose if @wrong_guesses.length >= 7
    return :win unless word_with_guesses.include?('-') # unless: "if ot", the player wins if no - is left and number of wrong guesses is < 7
    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end
