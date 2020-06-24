module Location
  MIN_DISTANCE = 0.1 #minimum distance (in miles) for a wifi network to be considered in range of a student

  def check_address(address)
    # Confirms address user entered exists
    Dotenv.load('.env') #Loads the API key using the Dotenv GEM - you must re-create the .env file in root directory
    Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY']
    
    location = Geokit::Geocoders::GoogleGeocoder.geocode address
    
    if location.street_address == "" || location.street_address == nil  || location.street_name == "" || location.street_name == nil || location.street_number == "" || location.street_number == nil
      return false
    else
      return location
    end
  end    

  def get_location(address)
    #Returns a location object of a street address using Geokit and the Google API
    Dotenv.load('.env') #Loads the API key
    Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY'] #Loads the API key using the Dotenv GEM - you must re-create the .env file in root directory
    Geokit::Geocoders::GoogleGeocoder.geocode address
  end
   
  end