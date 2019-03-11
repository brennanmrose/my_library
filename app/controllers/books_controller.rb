class BooksController < ApplicationController

	# index
	get '/books' do 
		if logged_in?
			erb :'books/index'
		else 
			redirect '/login'
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
			end
		else
			# add flash error message
			redirect '/books/new'
		end
	end

	# show
	get '/books/:slug' do
		if logged_in? 
			@book = current_user.books.find_by_slug(slug)
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
		@book = current_user.books.find_by_slug(slug)
		if valid_user?
  			erb :'books/edit'
  	else 
  		redirect '/books'
  	end 
	end

	# update
	patch '/books/:slug' do 
		@book = current_user.books.find_by_slug(slug)
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
		else
			# flash message invalid book params
			redirect "/books/#{@book.slug}/edit"
		end
	end 

	# delete
	delete '/books/:slug' do
		if logged_in?
			@book = current_user.books.find_by_slug(slug)
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

	def valid_user?
		@book.user == current_user
	end

	def add_book_to_existing_author
		@author = Author.find_by(id: author_id)
		@book.author = @author
		@book.save 
	end

	def find_or_create_author
    @author = current_user.authors.find_by_name(params[:author][:name])
		if @author.present? && current_user.authors.include?(@author)
			@book.author = @author
			@book.save
    else 
      @author = Author.create(author_params)
      @book.author = @author
    	@book.save
    end
	end

	def find_or_create_genre
		@genre = current_user.genres.find_by(name: params[:genre][:name])
		if @genre.present? && current_user.genres.include?(@genre)
			@book.genres << @genre
		else
			@genre = Genre.create(genre_params)
			@book.genres << @genre
		end
	end

end
