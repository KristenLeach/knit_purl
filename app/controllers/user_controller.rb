class UserController < ApplicationController

    get '/signup' do 
        !logged_in? ? (erb :'/users/signup') : (redirect "/")
    end 

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        erb :'users/account'
    end

    post '/signup' do
        user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
        !!user.save ? (session[:user_id] = user.id) && (redirect "/users/#{user.slug}") : flash[:error] = "Something went wrong. Please try again!" && (redirect "/signup")
    end

    get '/login' do
        user = User.find_by(:username => params[:username])
        !logged_in? ? (erb :'/users/login') : (redirect "/users/#{user.slug}")
    end

    post "/login" do
        user = User.find_by(:username => params[:username])
        !!user && user.authenticate(params[:password]) ? (session[:user_id] = user.id) && (redirect "/users/#{user.slug}") : (redirect "/signup")
    end

    get "/logout" do
        !!logged_in? ? (session.destroy) && (redirect '/login') : (redirect "/")
    end

end