class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :stripped
      t.string :section
      t.string :sub_section
      t.date :birthday

      t.timestamps null: false
    end
  end
end
