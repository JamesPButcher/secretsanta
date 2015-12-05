class AddAvoidingGivingToIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :avoiding_giving_to_id, :integer
  end
end
