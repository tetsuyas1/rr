class Term < ActiveRecord::Base
  has_many :related_terms, :through => :term_relations, :class_name => "Term"
  has_many :term_relations
end
