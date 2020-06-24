class Student < ActiveRecord::Base
    has_secure_password

    validates :username, :email, :address, presence: true
    validates :username, :email, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { in: 6..20 }
    #has_many :contracts
    #has_many :providers, through: :contract
end