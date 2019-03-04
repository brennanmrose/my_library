class AuthorsController < ApplicationController

	get '/authors' do 
		@authors = []
		current_user.books.each do |book|
			@authors << book.author
		end
		erb :'authors/index'
	end

	get '/authors/:slug' do
		@artist = Artist.find_by_slug(params[:slug])
		erb :'authors/show'
	end

end