class AuthorTerm < ActiveRecord::Base
  belongs_to :author
  belongs_to :term
end
