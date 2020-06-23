class ContractsController < ApplicationController
    post '/contracts' do 
        if current_provider.id == params[:provider_id].to_i
            contract = Contract.create(name: params[:name], provider_id: params[:provider_id], wifi_name: params[:wifi_name], wifi_password: params[:wifi_password], approved: params[:approved], rating: 0)
            redirect "/provider/#{contract.provider.id}"
        else
            redirect "/"
        end
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
        if (params[:name].length > 0) && (params[:wifi_name].length > 0) && (params[:wifi_password].length > 0) && (params[:wifi_password].length > 0)
            @contract.update(:name => params[:name], :wifi_name => params[:wifi_name], :wifi_password => params[:wifi_password], :approved => params[:approved])   
            @contract.save
            redirect "/provider/#{@contract.provider.id}"
        else
            redirect "/contracts/#{contract.id}/edit"
        end
    end

    delete '/contracts/:id' do #delete action
        @contract = Contract.find_by_id(params[:id])
        if current_provider.id == @contract.provider.id
            @contract.delete
        end
        redirect "/provider/#{@contract.provider.id}"
      end

end