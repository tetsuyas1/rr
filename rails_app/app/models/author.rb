class Author < ActiveRecord::Base
  has_many :author_relations
  has_many :related_authors, :through => :author_relations, :class_name => "Author"
  has_many :author_terms
  has_many :related_terms, :through => "author_terms" , :class_name => "Term"
end
