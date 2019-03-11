class AuthorsController < ApplicationController

	get '/authors' do
		if logged_in?
			erb :'authors/index'
		else
			redirect '/login'
		end
	end

	get '/authors/:slug' do
		if logged_in?
			@author = current_user.authors.find_by_slug(slug)
			erb :'authors/show'
		else
			redirect '/login'
		end
	end

end