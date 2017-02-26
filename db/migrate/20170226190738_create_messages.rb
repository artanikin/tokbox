class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :session_user_id
      t.integer :room_id
      t.text :text

      t.timestamps
    end
  end
end
