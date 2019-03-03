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
			@book = Book.new(book_params)
			if author_id.present?
				@author = Author.find_by(author_id)
				@book.author = @author
				@book.save
			else
				@author = Author.create(author_params)
				@book.author = @author
				@book.save
			end
			if genre_name.present?
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

	def author_params
		params[:author]
	end

	def author_id
		params[:author][:id]
	end

	def genre_params
		params[:genre]
	end

	def genre_name
		params[:genre][:name]
	end

	def valid_book_params?
		params[:book][:title].present? && valid_author_params? && valid_genre_params?
	end

	def valid_author_params?
		params[:author][:name].present? || params[:author][:id].present?
	end

	def valid_genre_params?
		params[:genre][:name].present? || params[:book][:genre_ids].present?
	end

end

# Functionality to add:

# -remove author first_name & last_name from schema
# - stretch goal is to add way to sort author by last name first

# 	get '/books/:slug' do 
# 		if logged_in?
# 			@book = Book.find(params[:id])
# 			erb :'/books/show'
# 		else
# 			redirect '/login'
# 		end
# 	end
