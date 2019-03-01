class BooksController < ApplicationController

	get '/books/new' do 
		if logged_in?
			erb :'books/new'
		else
			redirect '/login'
		end
	end

	post '/books' do 
		if params[:book][:title].present? && params[:author][:first_name].present? && params[:author][:last_name].present? && params[:genre].present?
			@author = Author.create(first_name: params[:author][:first_name], last_name: params[:author][:last_name])
			@book = Book.new(title: params[:book][:title], author: @author)
			@book.genres.build(name: params[:genre])
			@book.save
			current_user.books << @book

			redirect "/users/#{current_user.slug}"
		else
			# add flash error message
			redirect '/books/new'
		end
	end

end