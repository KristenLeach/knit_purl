class ProjectController < ApplicationController

    get '/projects' do 
        if logged_in?
            @projects = Project.all
            erb :'/projects/index'
        else
            redirect '/login'
        end
    end

    get '/projects/new' do
        if logged_in?
            erb :'/projects/create'
        else 
            redirect '/login'
        end
    end

    post '/projects' do
        if params.empty?
            redirect '/projects/new'
        elsif logged_in? && !params.empty?
            @project = current_user.projects.create(name: params[:name], materials: params[:materials], instructions: params[:instructions])
            @project.save ? (redirect "/projects/#{@project.id}") : flash[:new] = "Your project could not be saved. Try again!" && (redirect '/projects/new')
        else 
            redirect '/login'
        end
        current_user.save
    end

    get '/projects/:id' do
        if logged_in?
            @project = Project.find_by_id(params[:id])
            erb :'/projects/show'
        else 
            redirect '/login'
        end
    end

    get '/projects/:id/edit' do 
        if logged_in?
            @project = Project.find_by_id(params[:id])
            erb :'/projects/edit'
        else 
            redirect '/login'
        end
    end

    patch '/projects/:id' do
        @project = Project.find_by_id(params[:id])
        if params.empty?
            redirect "/projects/#{@project.id}/edit"
        elsif logged_in? && !params.empty?
            @project.update(name: params[:name], materials: params[:materials], instructions: params[:instructions])
            redirect "/projects/#{@project.id}"
        else 
            redirect '/login'
        end
    end

    delete '/projects/:id/delete' do
        if logged_in?
            @project = Project.find_by_id(params[:id])
            if @project.user == current_user then @project.delete else redirect '/login' end
        else 
            redirect '/login'
        end
        redirect '/projects'
    end

end