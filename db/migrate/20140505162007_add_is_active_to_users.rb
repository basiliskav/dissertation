class AddIsActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_active, :integer, :null => false , :default => 1
  end
end
