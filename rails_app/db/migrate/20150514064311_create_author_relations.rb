class CreateAuthorRelations < ActiveRecord::Migration
  def change
    create_table :author_relations do |t|
      t.integer :author_id
      t.integer :related_author_id
      t.float :weight

      t.timestamps null: false
    end
  end
end
