class ProjectController < ApplicationController

    get '/projects' do 
        @projects = Project.all
        erb :'/projects/index'
    end

    get '/projects/new' do
        erb :'/projects/create'
    end

    post '/projects' do
        if params.empty?
            redirect '/projects/new'
        elsif logged_in? && !params.empty?
            @project = current_user.projects.create(name=> params[:name], materials=> params[:materials], instructions=> params[:instructions])
            @project.save ? (redirect "/projects/#{@project.slug}") : flash[:new] = "Your project could not be saved. Try again!" && (redirect '/projects/new')
        else 
            redirect '/login'
        end
        current_user.save
    end

    get '/projects/:slug' do
        if logged_in?
            @project = Project.find_by_slug(params[:slug])
            erb :'/projects/show'
        else 
            redirect '/login'
        end
    end

    get '/projects/:slug/edit' do 
        if logged_in?
            @project = Project.find_by_slug(params[:slug])
            erb :'/projects/edit'
        else 
            redirect '/login'
        end
    end

    patch '/projects/:slug' do
        @project = Project.find_by_slug(params[:slug])
        if params.empty?
            redirect "/projects/#{@project.slug}/edit"
        elsif logged_in? && !params.empty?
            @project.update(name: params[:name], materials: params[:materials], instructions: params[:instructions])
            redirect "/projects/#{@project.id}"
        else 
            redirect '/login'
        end
    end

    delete '/projects/:slug/delete' do
        if logged_in?
            @project = project.find_by_slug(params[:slug])
            if @project.user == current_user then @project.delete else redirect '/login' end
        else 
            redirect '/login'
        end
        redirect '/projects'
    end

end