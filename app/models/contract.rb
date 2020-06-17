class Contract < ActiveRecord::Base
    belongs_to :provider
    has_many :students, through: :provider
end