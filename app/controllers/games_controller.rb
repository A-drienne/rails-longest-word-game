require "open-uri"


class GamesController < ApplicationController
  def play
    vowels = (0..1).map { %w[a e i o u].to_a[rand(5)]}.join
    letters = (0..7).map { ('a'..'z').to_a[rand(26)] }.join
    @letters = vowels + letters
  end

  def score
    @split_user_word = params[:userWord].split('')
    @word = params[:userWord]

    if !check_collection(@split_user_word, params[:letters])
      @answer = "Sorry but #{params[:userWord].upcase} is not contained in: #{params[:letters]}"
    elsif english_word?(@word)
      raise
      @answer = "Sorry but #{params[:userWord].upcase} is not in the dictionary"
    else
      @answer = "You WIN!!!"
    end
  end

  def check_collection(split_user_word, letters)
    split_user_word.all? { |letter| letters.include?(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
