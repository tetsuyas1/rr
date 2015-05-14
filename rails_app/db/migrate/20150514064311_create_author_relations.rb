class CreateAuthorRelations < ActiveRecord::Migration
  def change
    create_table :author_relations do |t|
      t.integer :author_a_id
      t.integer :author_b_id
      t.float :weight

      t.timestamps null: false
    end
  end
end
