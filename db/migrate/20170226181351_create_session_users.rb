class CreateSessionUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :session_users do |t|
      t.integer :room_id, foreign_key: true
      t.integer :user_id, foreign_key: true
      t.string :token
      t.string :nikname
      t.string :role, default: "subscriber"

      t.timestamps
    end
    add_index :session_users, [:room_id, :user_id]
  end
end
