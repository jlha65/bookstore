class AddDefaultValueToShoppingCartData < ActiveRecord::Migration[7.0]
  def change
    change_column_default :books, :price, 1.0
  end
end
