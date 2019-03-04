class BooksController < ApplicationController

	# index
	get '/books' do 
		if logged_in?
			@books = current_user.books
			erb :'books/index'
		end
	end

	# new
	get '/books/new' do 
		if logged_in?
			erb :'books/new'
		else
			redirect '/login'
		end
	end

	# create
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

			redirect "/books/#{@book.slug}"
		else
			# add flash error message
			redirect '/books/new'
		end
	end

	# show
	get '/books/:slug' do
		@book = Book.find_by_slug(params[:slug])
		erb :'books/show'
	end

	# edit
	get '/books/:slug/edit' do 
		@book = Book.find_by_slug(params[:slug])
		erb :'books/edit'
	end

	# patch
	patch '/books/:slug' do 
		@book = Book.find_by_slug(params[:slug])
		if valid_book_params?
			@book.update(book_params)
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
			redirect "/books/#{@book.slug}" 
		end
	end 

	private

	def book_params
		params[:book]
	end

	def book_id
		params[:book][:id]
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
# - fix index view
# - edit title how to make it big enough for longer title
# update new to only show current users's books

# 	get '/books/:slug' do 
# 		if logged_in?
# 			@book = Book.find(params[:id])
# 			erb :'/books/show'
# 		else
# 			redirect '/login'
# 		end
# 	end
