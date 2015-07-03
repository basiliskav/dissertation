class AddParentIdToFolder < ActiveRecord::Migration
  def change
    add_reference :folders, :parent, index: true
  end
end
