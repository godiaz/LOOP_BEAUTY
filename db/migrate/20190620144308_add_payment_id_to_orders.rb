class AddPaymentIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :stripe_id, :string
  end
end
