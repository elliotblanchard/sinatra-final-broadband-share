class Student < ActiveRecord::Base
    has_secure_password

    validates :username, :email, :address, presence: true
    validates :username, :email, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    #has_many :contracts
    #has_many :providers, through: :contract
end