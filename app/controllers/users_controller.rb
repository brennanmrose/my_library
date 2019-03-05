class UsersController < ApplicationController


	get '/signup' do 
		if logged_in?
			redirect '/users/show'
		else
			erb :'users/signup'
		end
	end

	post '/signup' do 
		# if params[:username].empty? || params[:email].empty? || params[:password].empty?
		if valid_user_params?
			@user = User.create(username: params[:username], email: params[:email], password: params[:password])
			redirect '/login'
		else 
			# add flash error message
			redirect '/signup'
		end
	end

	get '/login' do 
		if logged_in?
			redirect :'books/index'
		else
			erb :'users/login'
		end
	end

	post '/login' do
		@user = User.find_by(username: params[:username])
		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id 
			redirect "/users/#{@user.slug}"
		else
			redirect '/signup'
		end
	end
		
	# show
	get '/users/:slug' do 
		if logged_in?
			@user = current_user
			erb :'users/show'
		else
			redirect '/signup'
		end
	end

	get '/logout' do 
		if logged_in?
			session.clear
			redirect '/login'
		else
			redirect '/'
		end
	end

	private

	def valid_user_params?
		params[:username].present? && params[:email].present? && params[:password].present?
	end

end