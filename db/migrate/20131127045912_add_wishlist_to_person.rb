class AddWishlistToPerson < ActiveRecord::Migration
  def change
    add_column :people, :wishlist, :string
  end
end
