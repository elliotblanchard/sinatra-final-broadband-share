class Contract < ActiveRecord::Base
    belongs_to :provider

    validates :name, :wifi_name, :wifi_password, :approved, :rating, presence: true
end