class GenresController < ApplicationController

	get '/genres' do 
		if logged_in?
			@genres = []
			current_user.books.each do |book|
				book.genres.each do |genre|
					@genres << genre
				end
			end
			erb :'genres/index'
		else
			redirect '/login'
		end
	end

	get '/genres/:slug' do
		if logged_in?
			@genre = Genre.find_by_slug(slug)
			erb :'genres/show'
		else
			redirect '/login'
		end
	end

end