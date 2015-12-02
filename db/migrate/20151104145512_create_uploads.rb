class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :attachment, :null => false
      t.belongs_to :user, index: true
      t.belongs_to :folder, index: true

      t.timestamps
    end
  end
end
