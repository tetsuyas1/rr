class CreateTermRelations < ActiveRecord::Migration
  def change
    create_table :term_relations do |t|
      t.integer :term_a_id
      t.integer :term_b_id
      t.float :weight

      t.timestamps null: false
    end
  end
end
