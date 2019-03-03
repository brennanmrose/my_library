class UsersController < ApplicationController

	get '/users/:slug' do 
		@user = User.find_by_slug(params[:slug])
		erb :'users/show'
	end

	get '/signup' do 
		if logged_in?
			redirect '/users/show'
		else
			erb :'users/signup'
		end
	end

	post '/signup' do 
		if params[:username].empty? || params[:email].empty? || params[:password].empty?
			# add flash error message
			redirect '/signup'
		else 
			@user = User.create(username: params[:username], email: params[:email], password: params[:password])
			redirect '/login'
		end
	end

	get '/login' do 
		if logged_in?
			redirect :'users/show'
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

	get '/logout' do 
		if logged_in?
			session.clear
			redirect '/login'
		else
			redirect '/'
		end
	end

end