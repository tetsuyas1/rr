class Article < ActiveRecord::Base
  has_many :article_authors
  has_many :authors, :through => :artcile_authors
  has_many :article_terms
  has_many :terms, :through => :article_terms
end
