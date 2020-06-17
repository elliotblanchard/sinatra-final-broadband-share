class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :address
      t.string :latlong
      t.timestamps null: false  
    end     
  end
end
