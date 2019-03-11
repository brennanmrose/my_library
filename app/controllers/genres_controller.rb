class GenresController < ApplicationController

	get '/genres' do 
		if logged_in?
			erb :'genres/index'
		else
			redirect '/login'
		end
	end

	get '/genres/:slug' do
		if logged_in?
			@genre = current_user.genres.find_by_slug(slug)
			erb :'genres/show'
		else
			redirect '/login'
		end
	end

end