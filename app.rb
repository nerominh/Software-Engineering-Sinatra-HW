require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }  

  # Before and after: code that runs around EVERY REQUEST
  before do
    @game = session[:game] || WordGuesserGame.new('') # Load the game from the cookie
    # Basically: game = game from the cookie, OR an empty game if there isn't any
  end

  after do
    session[:game] = @game # Save it back into the cookie
  end

  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new' # redirect to /new
  end

  get '/new' do
    erb :new # renders views/new.erb (the file in views), looks for views/new.erb --> run through embedded Ruby
  end

  post '/create' do # This route create a new game
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word # get the random word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word) # Make new game
    redirect '/show' # Show it
  end

  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0] # params = hash of what the user submitted in the form
    # .to_s: make sure no crash if the box empty, [0] keep only the first character

    ### YOUR CODE HERE ###
    @game.guess(letter) # Part 1 to method updates guesses/wrong_guesses
    redirect '/show'
  end

  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
    erb :show # You may change/remove this line
  end

  get '/win' do
    ### YOUR CODE HERE ###
    erb :win # You may change/remove this line
  end

  get '/lose' do
    ### YOUR CODE HERE ###
    erb :lose # You may change/remove this line
  end
end
