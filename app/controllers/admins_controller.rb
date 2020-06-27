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
        @providers = Provider.all
        @students = Student.all
        #Get all active contracts
        @active_contracts = Contract.all.select { |contract| contract.approved == 1 }
        #Loads the API key for the map 
        Dotenv.load('.env') 
        @api_key =  ENV['GOOGLE_MAPS_API_KEY']
        erb:'/admins/show' 
    else
        redirect '/'
    end
end 

end