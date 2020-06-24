class Provider < ActiveRecord::Base
    has_secure_password

    has_many :contracts

    validates :username, :email, :address, presence: true
    validates :username, :email, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { in: 6..20 }

    #has_many :students, through: :contract
end