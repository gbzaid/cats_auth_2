class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false, unique: true
      t.string :password_digest, null: false
      t.string :session_token, null: false

      t.timestamp

      t.index :username
      t.index :session_token, unique: true
    end
    
  end
end
