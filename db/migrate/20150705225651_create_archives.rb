class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.string :name, :null => false
      t.text :text
      t.belongs_to :user, index: true
      t.belongs_to :folder, index: true

      t.timestamps
    end
  end
end
