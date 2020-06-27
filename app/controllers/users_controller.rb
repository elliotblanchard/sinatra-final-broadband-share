require_relative '../../lib/location_module'

class UsersController < ApplicationController
    include Location

    get "/login" do
        if student_logged_in?
            redirect "/student/#{current_student.id}"
        elsif provider_logged_in?
            redirect "/provider/#{current_provider.id}"
        else
            erb :login
        end
    end

    post "/login" do
        if params[:user_type]
            if params[:user_type] == "student"
                user = Student.find_by(username: params[:username])
            else
                user = Provider.find_by(username: params[:username])
            end
            if user && user.authenticate(params[:password])
                params[:user_type] == "student" ? (session[:student_id] = user.id) : (session[:provider_id] = user.id)
                flash[:message] = "Welcome back"
                redirect "/#{user.class.name.downcase}s/#{user.id}"
            else
                flash[:error] = "Invalid username or password. Try again!"
                redirect '/login'
            end
        else
            flash[:error] = "No user type: need to choose student or provider."
            redirect "/login"
        end
    end

    get '/students/:id' do
        if ((student_logged_in?) && (current_student.id == params[:id].to_i)) || (admin_logged_in?)
            @student = Student.find(params[:id])
            @nearby_contracts = @student.get_nearby_contracts
            erb:'/students/show' 
        else
            redirect '/'
        end        
    end 

    get '/providers/:id' do
        if ((provider_logged_in?) && (current_provider.id == params[:id].to_i)) || (admin_logged_in?)
            @provider = Provider.find(params[:id])
            @nearby_students = @provider.get_nearby_students
            erb:'/providers/show' 
        else
            redirect '/'
        end
    end 

    get '/signup' do
       erb:'/signup' 
    end

    post "/signup" do
       # Can't use mass assignment on create b/c of need to construct address and latlong

        full_address = params[:address] + ", New York, NY, " + params[:zip]
        location = check_address(full_address)

        if location && params[:user_type] && (params[:password] == params[:password_confirm])
            if params[:user_type] == "student"
                user = Student.new(:username => params[:username], :email => params[:email], :password => params[:password], :address => full_address, :latlong => location.ll)
            elsif params[:user_type] == "provider"
                user = Provider.new(:username => params[:username], :email => params[:email], :password => params[:password], :address => full_address, :latlong => location.ll)
            end
            if user.save
                params[:user_type] == "student" ? (session[:student_id] = user.id) : (session[:provider_id] = user.id)
                flash[:message] = "#{user.class.name} created."
                redirect "/#{user.class.name.downcase}s/#{user.id}"
            else
                flash[:error] = "Signup failed: #{user.errors.full_messages.to_sentence}"
                redirect "/signup"
            end            
        else
            if !location
                flash[:error] = "Could not verify address."
            elsif params[:password] != params[:password_confirm]
                flash[:error] = "Passwords need to match."
            else
                flash[:error] = "No user type: need to choose student or provider."
            end
            redirect "/signup"
        end
    end

    get '/logout' do
        session.clear
        redirect '/login'
    end
end