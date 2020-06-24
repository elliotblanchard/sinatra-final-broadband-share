class Provider < ActiveRecord::Base
    has_secure_password

    has_many :contracts

    validates :username, :email, :address, presence: true
    validates :username, :email, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    
    #has_many :students, through: :contract
end