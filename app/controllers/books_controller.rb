class BooksController < ApplicationController

	get '/books/new' do 
		if logged_in?
			erb :'books/new'
		else
			redirect '/login'
		end
	end

	post '/books' do 
		binding.pry
	end

end