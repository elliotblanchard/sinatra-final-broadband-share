class Student < ActiveRecord::Base
    has_secure_password

    #has_many :contracts
    #has_many :providers, through: :contract
end