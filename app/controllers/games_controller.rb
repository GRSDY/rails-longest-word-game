require 'net/http'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = ('a'..'z').to_a
    @random_letter_array = @letters.sample(10).map(&:upcase)
    @random_string = @random_letter_array.join('')
    @random_string_html = "<div>#{@random_letter_array.join('</div><div>')}</div>"
  end

  def score
    @user_input_word = params[:word].upcase
    @user_input_letters = params[:letters]
    @letters_separated = @user_input_letters.split('').join(', ')

    url = "https://wagon-dictionary.herokuapp.com/#{@user_input_word}"

    uri = URI(url)
    response = Net::HTTP.get(uri)

    @result_api = JSON.parse(response)

    @contains_all_letters = @user_input_word.split('').to_set.subset?(@user_input_letters.split('').to_set)

    @result = "Congratulations! #{@user_input_word} is a valid English word!"

    unless @contains_all_letters
      @result = "Sorry but #{@user_input_word} can't be built out of #{@letters_separated}"
      return
    end

    if @result_api['found'] == false
      @result = "Sorry but #{@user_input_word} does not seem to be a valid English word..."
    end
  end
end
