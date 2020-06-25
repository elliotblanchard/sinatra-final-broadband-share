class ContractsController < ApplicationController
    post '/contracts' do 
        contract = Contract.new(name: params[:name], provider_id: params[:provider_id], wifi_name: params[:wifi_name], wifi_password: params[:wifi_password], approved: params[:approved], rating: 0)
        if (current_provider.id == params[:provider_id].to_i) && (contract.save)
            flash[:message] = "Share created."
            #contract = Contract.create(name: params[:name], provider_id: params[:provider_id], wifi_name: params[:wifi_name], wifi_password: params[:wifi_password], approved: params[:approved], rating: 0)
        else
            flash[:error] = "Share creation failed: #{contract.errors.full_messages.to_sentence}"
        end
        redirect "/providers/#{contract.provider.id}"
    end

    get '/contracts/:id/edit' do 
        @contract = Contract.find(params[:id])
        if current_provider.id == @contract.provider.id
            erb :'/contracts/edit'
        else
            redirect "/"
        end 
    end 
    
    patch '/contracts/:id' do
        @contract = Contract.find(params[:id])
        if params[:rating] == "-1" || params[:rating] == "1"
            #Student feedback on a contract rating only
            rating = @contract.rating
            rating = rating + params[:rating].to_i
            @contract.update(:rating => rating)
            @contract.save
            redirect "/students/#{current_student.id}"
        else
            #Provider edit on a contract overall
            @contract.update(:name => params[:name], :wifi_name => params[:wifi_name], :wifi_password => params[:wifi_password], :approved => params[:approved])
            #if (params[:name].length > 0) && (params[:wifi_name].length > 0) && (params[:wifi_password].length > 0) && (params[:wifi_password].length > 0)
            if @contract.save
                #@contract.update(:name => params[:name], :wifi_name => params[:wifi_name], :wifi_password => params[:wifi_password], :approved => params[:approved])   
                #@contract.save
                flash[:message] = "Share updated."
                redirect "/providers/#{@contract.provider.id}"
            else
                flash[:error] = "Share update failed: #{@contract.errors.full_messages.to_sentence}"
                redirect "/contracts/#{@contract.id}/edit"
            end
        end
    end

    delete '/contracts/:id' do #delete action
        @contract = Contract.find_by_id(params[:id])
        if current_provider.id == @contract.provider.id
            @contract.delete
        end
        redirect "/providers/#{@contract.provider.id}"
      end

end