class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :name
      t.integer :provider_id       
      t.string :wifi_name
      t.string :wifi_password
      t.integer :duration_days     
      t.integer :approved
      t.integer :rating
      t.timestamps null: false  
    end       
  end
end

# !!! there needs to be a way for students to rate if the wifi works or not, so providers can't post bogus wifi, or know that something's wrong with the connection

