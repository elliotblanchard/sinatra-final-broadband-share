class UsersController < ApplicationController
    MIN_DISTANCE = 0.3 #minimum distance (in miles) for a wifi network to be considered in range of a student

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
        if (student_logged_in?) && (current_student.id == params[:id].to_i)
            @student = Student.find(params[:id])

            #Get all active contracts
            active_contracts = Contract.all.select { |contract| contract.approved == 1 }

            #Get all active contracts in range
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
        if (provider_logged_in?) && (current_provider.id == params[:id].to_i)
            @provider = Provider.find(params[:id])
            "at provider profile page"
            #erb:'/providers/show' 
        else
            redirect '/'
        end
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
        
        # !!! need to test if the address is valid using check_address(address)

        if params[:user_type] == "student"
            # !!! may not need to have / save latlong if you have a verified street address
            student = Student.new(:username => params[:username], :email => params[:email], :password => params[:password], :address => full_address, :latlong => location.ll)
            if student.save
                session[:student_id] = student.id
                redirect "/student/#{student.id}"
            else
                redirect "/signup"
            end
        else
            # !!! may not need to have / save latlong if you have a verified street address
            provider = Provider.new(:username => params[:username], :email => params[:email], :password => params[:password], :address => full_address, :latlong => location.ll)
            if provider.save
                session[:provider_id] = provider.id
                redirect "/provider/#{provider.id}"
            else
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