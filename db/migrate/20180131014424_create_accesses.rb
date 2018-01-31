class CreateAccesses < ActiveRecord::Migration[5.1]
  def change
    create_table :accesses do |t|
      t.references :user, foreign_key: true
      t.references :message, foreign_key: true
      t.integer :kind, default: 0

      t.timestamps
    end
  end
end
