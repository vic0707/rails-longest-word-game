class PagesController < ApplicationController
	def game
		@random_letters = generate_grid(10)
	end

	def score
		@word = params[:query]
		@start_time = params[:start_time]
		@random_letters = params[:random_letters]
		@end_time = Time.now
		@results = run_game(@word, @random_letters, @start_time, @end_time)
	end

	private

	def generate_grid(grid_size)
  		# TODO: generate random grid of letters
  		random_array = []
  		(1..grid_size).each { random_array.push(('A'..'Z').to_a.sample) }
  		random_array
	end

	def run_game(attempt, grid, start_time, end_time)
  		# TODO: runs the game and return detailed hash of result
  		result = {}
  		attempt.split(//).each do |value|
  			if grid.include?(value.upcase)
  				grid.delete(value.upcase)
  			else
  				return result = { time: end_time.to_i - start_time.to_i, translation: nil, score: 0, message: "not in the grid" }
  			end
  		end
  		translation =  translation(attempt)

  		if translation != attempt
  			result = { time: end_time.to_i - start_time.to_i, translation: translation, score: attempt.length, message: "Good job" }
  			result[:message] = "well done" if attempt.length > 4
  			#result[:message] = "You are slow" && result[:score] = attempt.length - 1 if end_time.to_i - start_time.to_i > 10
  		else
  			result = { time: end_time.to_i - start_time.to_i, translation: nil, score: 0, message: "not an english word" }
  		end
  		result
	end

	def translation(attempt)
		url = open("https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=98f0e612-fa17-4b69-8d54-93ba069c438d&input=#{attempt}").read
		word = JSON.parse(url)
		"#{word['outputs'][0]['output']}"
	end
end
