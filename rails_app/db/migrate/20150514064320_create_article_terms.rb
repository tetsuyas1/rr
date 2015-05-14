class CreateArticleTerms < ActiveRecord::Migration
  def change
    create_table :article_terms do |t|
      t.references :article, index: true
      t.references :term, index: true

      t.timestamps null: false
    end
    add_foreign_key :article_terms, :articles
    add_foreign_key :article_terms, :terms
  end
end
