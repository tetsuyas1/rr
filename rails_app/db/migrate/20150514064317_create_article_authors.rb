class CreateArticleAuthors < ActiveRecord::Migration
  def change
    create_table :article_authors do |t|
      t.references :article, index: true
      t.references :author, index: true

      t.timestamps null: false
    end
    add_foreign_key :article_authors, :articles
    add_foreign_key :article_authors, :authors
  end
end
