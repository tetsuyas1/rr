class TermRelation < ActiveRecord::Base
  belongs_to :term
  belongs_to :related_term, :class_name => "Term", :foreign_key => "related_term_id"
end
