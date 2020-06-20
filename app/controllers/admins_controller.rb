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
        #erb:'/admins/show' 
    else
        redirect '/'
    end
end 

end