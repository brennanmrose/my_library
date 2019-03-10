class BooksController < ApplicationController

	# index
	get '/books' do 
		if logged_in?
			@books = current_user.books
			erb :'books/index'
		else 
			redirect '/login'
		end
	end

	# new
	get '/books/new' do 
		if logged_in?
			@authors = []
			@genres = []
			current_user.books.each do |book|
				@authors << book.author
				book.genres.each do |genre|
					@genres << genre
				end
			end
			erb :'books/new'
		else 
			redirect '/login'
		end
	end

	# create
	post '/books' do 
		if valid_book_params?
			binding.pry
			if find_book_by_title?
				# add flash message stating that book already exists
				redirect '/books'
			elsif
				@book = Book.new(book_params)
				if author_id.present?
					add_book_to_existing_author
				else
					find_or_create_author
				end
				if genre_name.present?
					find_or_create_genre
				end
				@current_user.books << @book
				redirect "/books/#{@book.slug}"
			else
			# add flash error message
				redirect '/books/new'
			end
		end
	end

	# show
	get '/books/:slug' do
		if logged_in? 
			find_book_by_slug
			if valid_user?
				erb :'books/show'
			else
				# flash that book is not in your library, here is your library
				redirect '/books'
			end
		else
				redirect '/login'
		end
	end

	# edit
	get '/books/:slug/edit' do 
		@book = Book.find_by_slug(slug)
		if valid_user?
  			erb :'books/edit'
  	else 
  		redirect '/books'
  	end 
	end

	# update
	patch '/books/:slug' do 
		@book = Book.find_by_slug(slug)
		if valid_book_params?
			@book.update(book_params)
			if author_id.present?
				add_book_to_existing_author
			else
				find_or_create_author
			end
			if genre_name.present?
				find_or_create_genre
			end
			redirect "/books/#{@book.slug}" 
		end
	end 

	# delete
	delete '/books/:slug' do
		if logged_in?
			@book = Book.find_by_slug(slug)
			if valid_user?
  			@book.delete
  			redirect '/books'
  		else 
  			redirect '/books'
  		end 
		else
			redirect '/login'
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

	def find_book_by_title?
  	!!(current_user.books.find_by(title: params[:book][:title]))
	end

	def find_book_by_slug
		@books = @current_user.books
		@book = @books.find_by_slug(slug)
	end

	def valid_user?
		@book.user == current_user
	end

	def add_book_to_existing_author
		@author = Author.find_by(id: author_id)
		@book.author = @author
		@book.save 
	end

	def find_or_create_author
		@author = Author.find_or_create_by(author_params)
		@book.author = @author
		@book.save 
	end

	def find_or_create_genre
		@genre = Genre.find_or_create_by(genre_params)
		if !(@book.genres.include?(@genre))
			@book.genres << @genre
		end
	end

end
