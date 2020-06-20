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

    get '/signup' do
       erb:'/signup' 
    end

    post "/signup" do
        # !!! need to check that the username or email isn't already taken in students / providers
        # !!! need to test if the address is valid
        # !!! need to test if the email address is valid
        # !!! need to test password for complexity / length + both passwords match
        # !!! need to make sure that no fields are blank
        # Can't use mass assignment on create b/c of need to construct address and latlong
        full_address = params[:address] + ", New York, NY, " + params[:zip]
        Dotenv.load('.env') #Loads the API key using the Dotenv GEM
        Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY'] #Loads the API key into Geokit
        location = Geokit::Geocoders::GoogleGeocoder.geocode full_address

        if params[:user_type] == "student"
            student = Student.new(:username => params[:username], :email => params[:email], :password => params[:password], :address => full_address, :latlong => location.ll)
            if student.save
                session[:student_id] = student.id
                redirect "/student/#{student.id}"
            else
                redirect "/signup"
            end
        else
            provider = Provider.new(:username => params[:username], :email => params[:email], :password => params[:password], :address => full_address, :latlong => location.ll)
            if provider.save
                session[:provider_id] = provider.id
                redirect "/provider/#{provider.id}"
            else
                redirect "/signup"
            end
        end        

        # Signup code from fwtwitter
		#user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
        #if (user.save) && (params[:username].length > 0) && (params[:email].length > 0)
        #   session[:user_id] = user.id
		#	redirect "/tweets"
		#else
		#	redirect "/signup"
        #end
        # Check location is valid from CLI
        # Confirms address user entered exists
        #Dotenv.load('.env') #Loads the API key using the Dotenv GEM - you must re-create the .env file in root directory
        #Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY']
        
        #location = Geokit::Geocoders::GoogleGeocoder.geocode address
        
        #if location.street_address == "" || location.street_address == nil  || location.street_name == "" || location.street_name == nil || location.street_number == "" || location.street_number == nil
        #    return false
        #else
        #return location.city
        #end 
    end

    get '/logout' do
        session.clear
        redirect '/login'
    end
end