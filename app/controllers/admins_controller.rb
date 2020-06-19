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
    # !!! need to only allow the logged in admin with correct ID to see this page
    "at admin profile page"
     #erb:'/admins/show' 
end 

end