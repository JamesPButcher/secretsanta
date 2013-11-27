class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :email
      t.integer :giving_to_id
      t.integer :receiving_from_id

      t.timestamps
    end
  end
end
