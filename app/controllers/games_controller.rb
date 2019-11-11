require 'open-uri'

class GamesController < ApplicationController
  def new
    @new_grid = Array.new(10) { ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def score
    @start_time = Time.parse(params[:start])
    attempt = params[:play]
    grid = params[:grid].split
    time_taken = Time.now - @start_time
    @score = score_and_message(attempt, grid, time_taken)
  end

  private

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        "well done your score is : #{compute_score(time, attempt)}"
      else
        'not an english word'
      end
    else
      'not in the grid'
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def compute_score(time_taken, attempt)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end
end
