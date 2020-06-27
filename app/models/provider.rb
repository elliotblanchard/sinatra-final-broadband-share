require_relative '../../lib/location_module'

class Provider < ActiveRecord::Base
    include Location

    has_secure_password

    has_many :contracts

    validates :username, :email, :address, presence: true
    validates :username, :email, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { in: 6..20 }

    def get_nearby_students
        #Searching for nearby students will have to be disabled if number of students gets large - right now breaks out of loop after the first student found to save time
        provider_location = get_location(self.address) #GeoKit location object
        nearby_students = false
        Student.all.each do |student|
            student_location = get_location(student.address) #GeoKit location object
            distance = provider_location.distance_to(student_location)
            if distance < MIN_DISTANCE
                nearby_students = true
                break
            end
        end
        return nearby_students    
    end
end