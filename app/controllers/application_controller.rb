require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    register Sinatra::Flash
    # !!! isn't this session secret insecure b/c it is on github?
    set :session_secret, "aPdSgVkXp2s5v8y/B?E(H+MbQeThWmZq3t6w9z$C&F)J@NcRfUjXn2r5u7x!A%D*G-KaPdSgVkYp3s6v9y/B?E(H+MbQeThWmZq4t7w!z%C&F)J@NcRfUjXn2r5u8x/A?D(G-KaPdSgVkYp3s6v9y$B&E)H@MbQeThWmZq4t7w!z%C*F-JaNdRfUjXn2r5u8x/A?D(G+KbPeShVmYp3s6v9y$B&E)H@McQfTjWnZr4t7w!z%C*F-JaNdRgUkXp2s"
  end

  get "/" do
    erb :welcome
  end

  helpers do
    def student_logged_in?
			!!session[:student_id]
    end  
    def provider_logged_in?
			!!session[:provider_id]
    end 
    def admin_logged_in?
			!!session[:admin_id]
		end     
    def current_student
      Student.find_by(id: session[:student_id])
    end
    def current_provider
      Provider.find_by(id: session[:provider_id])
    end
    #def check_address(address)
      # !!! should this be in the model instead of view?
      # Confirms address user entered exists
    #  Dotenv.load('.env') #Loads the API key using the Dotenv GEM - you must re-create the .env file in root directory
    #  Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY']
      
    #  location = Geokit::Geocoders::GoogleGeocoder.geocode address
      
    #  if location.street_address == "" || location.street_address == nil  || location.street_name == "" || location.street_name == nil || location.street_number == "" || location.street_number == nil
    #    return false
    #  else
    #    return location.city
    #  end
    #end    
    #def get_location(address)
      # !!! should this be in the model instead of view?
      #Returns a location object of a street address using Geokit and the Google API
    #  Dotenv.load('.env') #Loads the API key
    #  Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY'] #Loads the API key using the Dotenv GEM - you must re-create the .env file in root directory
    #  Geokit::Geocoders::GoogleGeocoder.geocode address
    #end
  end

end
