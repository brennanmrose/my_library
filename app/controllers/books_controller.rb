class BooksController < ApplicationController

	get '/books/new' do 
		if logged_in?
			erb :'books/new'
		else
			redirect '/login'
		end
	end

	post '/books' do 
		if valid_book_params?
			@author = Author.create(author_params)
			@book = Book.new(book_params)
			@book.author = @author
			@book.save
			if params[:genre][:name] != ""
				@genre = Genre.new(genre_params)
				@book.genres << @genre
			end
			current_user.books << @book

			redirect "/users/#{current_user.slug}"
		else
			# add flash error message
			redirect '/books/new'
		end
	end

	private

	def book_params
		params[:book]
	end

	def valid_book_params?
		params[:book][:title].present? && params[:author][:name].present? && params[:genre].present?
	end

	def author_params
		params[:author]
	end

	def genre_params
		params[:genre]
	end
end

# Functionality to add:

# - create checkbox for creating author

# 	get '/books/:slug' do 
# 		if logged_in?
# 			@book = Book.find(params[:id])
# 			erb :'/books/show'
# 		else
# 			redirect '/login'
# 		end
# 	end
