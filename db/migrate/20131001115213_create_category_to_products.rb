class CreateCategoryToProducts < ActiveRecord::Migration
  def change
    create_table :category_to_products do |t|
      t.integer :product_id
      t.integer :category_id

      t.timestamps
    end
  end
end
