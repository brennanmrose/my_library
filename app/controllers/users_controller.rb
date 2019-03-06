class UsersController < ApplicationController

	get '/users/:slug' do 
		if logged_in?
			@user = current_user
			erb :'users/show'
		else
			redirect '/login'
		end
	end


	get '/signup' do 
		if logged_in?
			redirect "/users/#{@user.slug}"
		else
			erb :'users/signup'
		end
	end

	post '/signup' do 
		if find_by_username? || find_by_email?
			redirect '/login'
		elsif valid_user_params? 
			create_user
			redirect "/users/#{@user.slug}"
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
			# add flash saying they need to sign up first
			redirect '/signup'
		end
	end
		

	get '/users/:slug/edit' do 
		if logged_in?
			@user = current_user
			erb :'users/edit'
		else
			redirect '/login'
		end
	end

	patch '/users/:slug' do 
		if @user = current_user
			@user.update(user_params)
			redirect "/users/#{@user.slug}"
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

	def user_params
		params[:user]
	end

	def find_by_username?
		!!(User.find_by(username: params[:username]))
	end

	def find_by_email?
		!!(User.find_by(email: params[:email]))
	end

	def create_user
		@user = User.create(username: params[:username], email: params[:email], password: params[:password])
	end

end