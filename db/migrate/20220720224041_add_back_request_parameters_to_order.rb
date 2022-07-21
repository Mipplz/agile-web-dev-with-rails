class AddBackRequestParametersToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :issuer_response_code, :string, null: true
    add_column :orders, :reject_reason, :string, null: true
  end
end
