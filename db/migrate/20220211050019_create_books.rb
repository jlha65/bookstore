class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.integer :book_id
      t.string :title
      t.string :description
      t.string :author
      t.float :price
      t.integer :stock
      t.boolean :available

      t.timestamps
    end
    add_index :books, :book_id
  end
end
