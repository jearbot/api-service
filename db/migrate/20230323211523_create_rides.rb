class CreateRides < ActiveRecord::Migration[7.0]
  def change
    create_table :rides do |t|
      t.string :external_id, null: false, index: true
      t.string :start_address, null: false, index: true
      t.string :start_coordinates
      t.string :destination_address, null: false, index: true
      t.string :destination_coordinates
      t.timestamps
      t.references :driver, foreign_key: true
      t.timestamp :deleted_at
      t.float :commute_distance
      t.float :commute_duration
      t.float :ride_distance
      t.float :ride_duration
      t.float :earnings
      t.float :score
      t.index [:start_address, :destination_address], unique: true
    end
  end
end
