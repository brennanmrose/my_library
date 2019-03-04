class AuthorsController < ApplicationController

	get '/authors' do
		if logged_in?
			@authors = []
			current_user.books.each do |book|
				@authors << book.author
			end
			erb :'authors/index'
		else
			redirect '/login'
		end
	end

	get '/authors/:slug' do
		if logged_in?
			@author = Author.find_by_slug(slug)
			erb :'authors/show'
		else
			redirect '/login'
		end
	end

end