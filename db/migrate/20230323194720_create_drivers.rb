class CreateDrivers < ActiveRecord::Migration[7.0]
  def change
    create_table :drivers do |t|
      t.string :external_id, null: false, index: true
      t.string :home_address, unique: true, null: false, index: true
      t.string :home_coordinates
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
