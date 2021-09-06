class CreateQcms < ActiveRecord::Migration[5.0]
  def change
    create_table :qcms do |t|
      t.text :statement
      t.boolean :many_answers
      t.integer :chapter_id
      t.integer :position

      t.timestamps
    end
  end
end
