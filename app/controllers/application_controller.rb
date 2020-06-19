require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
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
    def current_student
      Student.find_by(id: session[:student_id])
    end
    def current_provider
      Provider.find_by(id: session[:provider_id])
    end

  end

end
