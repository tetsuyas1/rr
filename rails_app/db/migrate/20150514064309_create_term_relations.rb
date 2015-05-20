class CreateTermRelations < ActiveRecord::Migration
  def change
    create_table :term_relations do |t|
      t.integer :term_id
      t.integer :related_term_id
      t.float :weight
      t.timestamps null:false
    end
  end
end
