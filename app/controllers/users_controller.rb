require_relative '../../lib/location_module'

class UsersController < ApplicationController
    include Location

    MIN_DISTANCE = 0.1 #minimum distance (in miles) for a wifi network to be considered in range of a student

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
        binding.pry
        if params[:user_type] == "student"
            student = Student.find_by(username: params[:username])
            if student && student.authenticate(params[:password])
                session[:student_id] = student.id
                flash[:message] = "Welcome back"
                redirect "/student/#{student.id}"
            else
                flash[:error] = "Invalid username or password. Try again!"
                redirect '/login'
            end
        else
            provider = Provider.find_by(username: params[:username])
            if provider && provider.authenticate(params[:password])
                session[:provider_id] = provider.id
                flash[:message] = "Welcome back"
                redirect "/provider/#{provider.id}"
            else
                flash[:error] = "Invalid username or password. Try again!"
                redirect '/login'
            end
        end
    end

    get '/student/:id' do
        if ((student_logged_in?) && (current_student.id == params[:id].to_i)) || (admin_logged_in?)
            @student = Student.find(params[:id])

            #Get all active contracts
            active_contracts = Contract.all.select { |contract| contract.approved == 1 }

            #Get all active contracts in range
            # !!! should this be in the model instead of view?
            student_location = get_location(@student.address) #GeoKit location object
            @nearby_contracts = []
            active_contracts.each do |contract|
                contract_location = get_location(contract.provider.address) #GeoKit location object
                distance = student_location.distance_to(contract_location)
                if distance < UsersController::MIN_DISTANCE
                    hash = { :contract => contract, :distance => distance }
                    @nearby_contracts << hash
                end
            end

            erb:'/students/show' 
        else
            redirect '/'
        end        
    end 

    get '/provider/:id' do
        if ((provider_logged_in?) && (current_provider.id == params[:id].to_i)) || (admin_logged_in?)
            @provider = Provider.find(params[:id])
            # !!! should this be in the model instead of view?
            #Searching for nearby students will have to be disabled if number of students gets large - RN breaks after the first student found to save time
            provider_location = get_location(@provider.address) #GeoKit location object
            @nearby_students = false
            Student.all.each do |student|
                student_location = get_location(student.address) #GeoKit location object
                distance = provider_location.distance_to(student_location)
                if distance < UsersController::MIN_DISTANCE
                    @nearby_students = true
                    break
                end
            end

            erb:'/providers/show' 
        else
            redirect '/'
        end
    end 

    get '/signup' do
       erb:'/signup' 
    end

    post "/signup" do
        # !!! need to test if the address is valid
        # !!! need to test both passwords match (there is an active record validator that can test if two fields match)
        # !!! need to make sure that no fields are blank (ZIP field can still be blank)
        # !!! need to check that they picked one radio button
        # Can't use mass assignment on create b/c of need to construct address and latlong
        full_address = params[:address] + ", New York, NY, " + params[:zip]
        Dotenv.load('.env') #Loads the API key using the Dotenv GEM
        Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY'] #Loads the API key into Geokit
        location = Geokit::Geocoders::GoogleGeocoder.geocode full_address
        
        # !!! need to test if the address is valid using check_address(address)

        if params[:user_type] == "student"
            # lat/long is needed for the maps on the admin page
            student = Student.new(:username => params[:username], :email => params[:email], :password => params[:password], :address => full_address, :latlong => location.ll)
            if student.save
                session[:student_id] = student.id
                flash[:message] = "Student created."
                redirect "/student/#{student.id}"
            else
                flash[:error] = "Signup failed: #{student.errors.full_messages.to_sentence}"
                redirect "/signup"
            end
        else
            # !!! may not need to have / save latlong if you have a verified street address
            provider = Provider.new(:username => params[:username], :email => params[:email], :password => params[:password], :address => full_address, :latlong => location.ll)
            if provider.save
                session[:provider_id] = provider.id
                flash[:message] = "Provider created."
                redirect "/provider/#{provider.id}"
            else
                flash[:error] = "Signup failed: #{provider.errors.full_messages.to_sentence}"
                redirect "/signup"
            end
        end        

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