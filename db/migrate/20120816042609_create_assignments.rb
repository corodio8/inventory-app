class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :user_id
      t.integer :computer_id
      t.date :assign_date

      t.timestamps
    end
  end
end
