class AuthorsController < ApplicationController

	get '/authors' do 
		@authors = []
		current_user.books.each do |book|
			@authors << book.author
		end
		erb :'authors/index'
	end

	get '/authors/:slug' do
		@author = Author.find_by_slug(slug)
		erb :'authors/show'
	end

end