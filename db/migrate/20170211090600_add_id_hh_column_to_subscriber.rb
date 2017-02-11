class AddIdHhColumnToSubscriber < ActiveRecord::Migration[5.0]
  def change
    add_column :subscribers, :id_hh, :string
  end
end
