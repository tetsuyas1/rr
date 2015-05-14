class CreateAuthorTerms < ActiveRecord::Migration
  def change
    create_table :author_terms do |t|
      t.references :author, index: true
      t.references :term, index: true
      t.float :weight

      t.timestamps null: false
    end
    add_foreign_key :author_terms, :authors
    add_foreign_key :author_terms, :terms
  end
end
