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
			if (params[:genre][:name])
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

	def book_params
		params[:book]
	end

	def valid_book_params?
		params[:book][:title].present? && params[:author][:first_name].present? && params[:author][:last_name].present? && params[:genre].present?
	end

	def author_params
		params[:author]
	end

	def genre_params
		params[:genre]
	end
end

# class BooksController < ApplicationController

# 	get '/books/new' do 
# 		if logged_in?
# 			erb :'books/new'
# 		else
# 			redirect '/login'
# 		end
# 	end

# 	post '/books' do 
# 			binding.pry
# 		if valid_book_params?
# 			@author = Author.create(author_params)
# 			@book = Book.new(book_params)
# 			@book.author = @author
# 			# @book.genres.build(name: params[:genre])
# 			@book.save
# 			current_user.books << @book

# 			redirect "/books/#{@book.slug}"
# 		else
# 			# add flash error message
# 			redirect '/books/new'
# 		end
# 	end

# 	get '/books/:slug' do 
# 		if logged_in?
# 			@book = Book.find(params[:id])
# 			erb :'/books/show'
# 		else
# 			redirect '/login'
# 		end
# 	end

# 	private



# end