require_relative '../../lib/location_module'

class Student < ActiveRecord::Base
    include Location

    has_secure_password

    validates :username, :email, :address, presence: true
    validates :username, :email, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { in: 6..20 }

    def get_nearby_contracts
            #Get all active contracts
            active_contracts = Contract.all.select { |contract| contract.approved == 1 }

            #Get all active contracts in range
            student_location = get_location(self.address) #GeoKit location object
            nearby_contracts = []
            active_contracts.each do |contract|
                contract_location = get_location(contract.provider.address) #GeoKit location object
                distance = student_location.distance_to(contract_location)
                if distance < MIN_DISTANCE
                    hash = { :contract => contract, :distance => distance }
                    nearby_contracts << hash
                end
            end
            return nearby_contracts
    end 
end