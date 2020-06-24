class Contract < ActiveRecord::Base
    belongs_to :provider

    validates :name, :wifi_name, :wifi_password, :approved, :rating, presence: true

    #has_many :students, through: :provider
end