class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
      t.string :serial_no
      t.integer :asset_tag
      t.string :computer_name
      t.string :make
      t.string :model

      t.timestamps
    end
  end
end
