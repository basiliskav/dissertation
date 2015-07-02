class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name, :null => false
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
