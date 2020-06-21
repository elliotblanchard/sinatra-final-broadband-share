class AdminsController < ApplicationController

get "/login_admin" do
    erb :login_admin
end

post "/login_admin" do
    admin = Admin.find_by(username: params[:username])
    if admin && admin.authenticate(params[:password])
        session[:admin_id] = admin.id
        redirect "/admin"
    else
        redirect '/login_admin'
    end
end

get '/admin' do
    if (admin_logged_in?)
        "at admin profile page"
        # !!! do you want to allow the admin page to change the minimum distance for a wifi to be in range?
        @providers = Provider.all
        @students = Student.all
        #Get all active contracts
        @active_contracts = Contract.all.select { |contract| contract.approved == 1 }
        Dotenv.load('.env') #Loads the API key
        @api_key =  ENV['GOOGLE_API_KEY'] #Loads the API key using the Dotenv GEM 
        erb:'/admins/show' 
    else
        redirect '/'
    end
end 

end