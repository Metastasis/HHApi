class CreateSubscribers < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribers do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phone
      t.boolean :isNotified

      t.timestamps
    end

    add_index :subscribers, :email, unique: true
  end
end
