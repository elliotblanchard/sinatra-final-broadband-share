class UsersController < ApplicationController

    get "/login" do
        erb :login
    end

    post "/login" do
        if params[:user_type] == "student"
            student = Student.find_by(username: params[:username])
            if student && student.authenticate(params[:password])
                session[:student_id] = student.id
                redirect "/student/#{student.id}"
            else
                redirect '/login'
            end
        else
            provider = Provider.find_by(username: params[:username])
            if provider && provider.authenticate(params[:password])
                session[:provider_id] = provider.id
                redirect "/provider/#{provider.id}"
            else
                redirect '/login'
            end
        end
    end

    get '/student/:id' do
        # !!! need to only allow the logged in student with correct ID to see their page
        @student = Student.find(params[:id])
        "at student profile page"
         #erb:'/students/show' 
    end 

    get '/provider/:id' do
        # !!! need to only allow the logged in provider with correct ID to see their page
        @provider = Provider.find(params[:id])
        "at provider profile page"
         #erb:'/providers/show' 
    end 
end