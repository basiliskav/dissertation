class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.string :name, :unique => true
      t.text :text
      t.belongs_to :user, index: true
      t.belongs_to :folder, index: true
      
      t.timestamps
    end
  end
end
