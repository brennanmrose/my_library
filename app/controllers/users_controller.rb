class UsersController < ApplicationController

	get '/users/:slug' do 
		@user = current_user
		if logged_in? && valid_user_account?
				erb :'users/show'
		elsif 
			logged_in? && !valid_user_account?
				# flash message this is not your acccount, redirecting to your account
				redirect "/users/#{@user.slug}"
		else
			redirect '/login'
		end
	end

	get '/signup' do 
		if logged_in?
			@user = current_user
			redirect "/users/#{@user.slug}"
		else
			erb :'users/signup'
		end
	end

	post '/signup' do 
		if find_by_username? || find_by_email?
			redirect '/login'
		elsif 
			valid_user_params? 
			@user = User.create(user_params)
			redirect "/users/#{@user.slug}"
		else 
			# add flash error message
			redirect '/signup'
		end
	end

	get '/login' do 
		if logged_in? && valid_user?
			redirect :'books/index'
		else
			erb :'users/login'
		end
	end

	post '/login' do
		@user = User.find_by(username: params[:user][:username])
		if @user && @user.authenticate(params[:user][:password])
			session[:user_id] = @user.id 
			redirect "/users/#{@user.slug}"
		else
			# add flash saying they need to sign up first
			redirect '/signup'
		end
	end
		
	get '/users/:slug/edit' do 
		@user = current_user
		if logged_in? && valid_user_account?
			erb :'users/edit'
		elsif 
			logged_in? && !valid_user_account?
				# add flash you must be logged in and this is your account
				redirect "/users/#{@user.slug}"
		else
			redirect '/login'
		end
	end

	patch '/users/:slug' do 
		if valid_user_params? && valid_user?
			@user = current_user
			@user.update(user_params)
			redirect "/users/#{@user.slug}"
		else
			redirect "/users/#{@user.slug}/edit"
		end
	end

	get '/logout' do 
		if logged_in? && valid_user?
			session.clear
			redirect '/login'
		elsif 
			logged_in? && !valid_user?
			redirect "/users/#{@user.slug}"
		else
			redirect'/login'
		end
	end

	private

	def valid_user_params?
		params[:user][:username].present? && params[:user][:email].present? && params[:user][:password].present?
	end

	def valid_user?
		session[:user_id] == current_user.id
	end

	def valid_user_account?
		current_user.slug == params[:slug]
	end

	def user_params
		params[:user]
	end

	def find_by_username?
		!!(User.find_by(username: params[:user][:username]))
	end

	def find_by_email?
		!!(User.find_by(email: params[:user][:email]))
	end

end